# extracted from fast_gettext
class TranslationKey < ActiveRecord::Base
  has_many :translations, :class_name => 'TranslationText', :dependent => :destroy

  accepts_nested_attributes_for :translations, :allow_destroy => true

  validates_uniqueness_of :key
  validates_presence_of :key

  before_save :normalize_newlines

  protected

  def normalize_newlines
    self.key = key.to_s.gsub("\r\n", "\n")
  end
end
