class SiteDefault < ActiveRecord::Base
  after_initialize :setup_nested_models
  before_validation :remove_empty_translations

  belongs_to :translation_key, :dependent => :destroy

  default_scope includes(:translation_key => [:translations])
  
  accepts_nested_attributes_for :translation_key

  validates_presence_of :description

  delegate :translations, :to => :translation_key
  
  def display_name
    translation_key.key
  end

  def self.dump(filename)
    File.open(filename, "w") do |file|
      attr = []
      SiteDefault.all.each do |s|
        attr << {
          :description => s.description,
          :translation_key_attributes => {
            :key => s.translation_key.key,
            :translations_attributes => translations_attributes(s.translations)
          }
        }
      end
      file.write(attr.to_json)
    end
  end

  def self.translations_attributes(translations)
    attr = {}
    translations.each_with_index do |t, i|
      attr[i] = t.attributes.slice('locale','text')
    end
    attr
  end
  
  def self.load(filename)
    attr = JSON::parse(File.read(Rails.root.join(filename)))
    SiteDefault.all.map(&:translations).map(&:all).flatten.map(&:destroy)
    SiteDefault.destroy_all
    attr.each do |a|
      SiteDefault.create!(a)
    end
  end

  private
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
