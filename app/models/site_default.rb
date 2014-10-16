class SiteDefault < ActiveRecord::Base
  audited
  before_destroy :destroy_translations
  after_initialize :setup_nested_models
  after_save :clear_caches
  after_destroy :clear_caches

  belongs_to :translation_key, :dependent => :destroy

  accepts_nested_attributes_for :translation_key

  validates_presence_of :description

  scope :by_key, -> { joins(:translation_key).order('translation_keys.key asc') }

  delegate :translations, :to => :translation_key

  def self.get(key)
    cache[key.to_s]
  end

  def self.cache(locale = I18n.locale)
    @caches ||= {}
    @caches[locale] ||= TranslationText.cache(locale)
  end

  def self.clear_caches
    @caches = {}
  end

  def self.dump(filename)
    attrs = []
    SiteDefault.all.each do |s|
      attrs << {
          description: s.description,
          translation_key_attributes: {
              key: s.translation_key.key,
              translations_attributes: map_translations_attributes(s.translations)
          }
      }
    end
    config = {Site.name.to_sym => attrs}
    write_config(filename, config)
  end

  def self.map_translations_attributes(translations)
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

  def display_name
    translation_key.key
  end

  def clear_caches
    self.class.clear_caches
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

  def destroy_translations
    translations.all.map(&:destroy)
  end

  def setup_nested_models
    unless translation_key
      build_translation_key
      Site.available_locales.each do |locale|
        translation_key.translations.build(:locale => locale)
      end
    end
  end
end
