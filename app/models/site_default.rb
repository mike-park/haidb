# == Schema Information
# Schema version: 20110320131630
#
# Table name: site_defaults
#
#  id                 :integer         primary key
#  translation_key_id :integer
#  description        :text
#  created_at         :timestamp
#  updated_at         :timestamp
#

class SiteDefault < ActiveRecord::Base
  acts_as_audited
  before_destroy :destroy_translations
  after_initialize :setup_nested_models
  before_validation :remove_empty_translations
  after_save :clear_translation_caches
  after_destroy :clear_translation_caches

  belongs_to :translation_key, :dependent => :destroy

  default_scope includes(:translation_key => [:translations])

  accepts_nested_attributes_for :translation_key

  validates_presence_of :description

  delegate :translations, :to => :translation_key

  def display_name
    translation_key.key
  end

  # get key via auto-translation of FastGettext. return nil if not set. (by default translation returns rhe )
  def self.get(key)
    value = _(key)
    value == key ? nil : value
  end

  def self.dump(filename)
    attrs = []
    SiteDefault.all.each do |s|
      attrs << {
          :description => s.description,
          :translation_key_attributes => {
              :key => s.translation_key.key,
              :translations_attributes => translations_attributes(s.translations)
          }
      }
    end
    config = { Site.name.to_sym => attrs }
    write_config(filename, config)
  end

  def self.translations_attributes(translations)
    attr = {}
    translations.each_with_index do |t, i|
      attr[i] = t.attributes.slice('locale', 'text')
    end
    attr
  end

  def self.load(filename)
    attrs = read_config(filename)
    attrs = attrs[Site.name.to_sym]
    SiteDefault.destroy_all
    attrs.each do |attr|
      SiteDefault.create!(attr)
    end
  end

  private

  def self.read_config(filename)
    YAML.load(File.read(Rails.root.join(filename)))
  end

  def self.write_config(filename, attrs)
    config = read_config(filename) rescue {}
    config.merge!(attrs)
    File.open(filename, "w") do |file|
      file.write(config.to_yaml)
    end
  end

  def clear_translation_caches
    # delete all cached app translations
    FastGettext.caches[FastGettext.default_text_domain] = {}
    # and force reload of cache of cache
    FastGettext.text_domain = FastGettext.text_domain
    # currently this has no effect; but technically it should be the correct way to reset translations
    I18n.reload!
  end

  def destroy_translations
    translations.all.map(&:destroy)
  end

  def remove_empty_translations
    translations.delete_if { |t| t.locale.blank? && t.text.blank? }
  end

  def setup_nested_models
    unless translation_key
      build_translation_key
      I18n.available_locales.each do |locale|
        translation_key.translations.build(:locale => locale)
      end
    end
  end

end
