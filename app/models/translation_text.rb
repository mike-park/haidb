# extracted from fast_gettext
class TranslationText < ActiveRecord::Base
  belongs_to :translation_key
  validates_presence_of :locale
  validates_uniqueness_of :locale, :scope=>:translation_key_id

  def self.cache(locale)
    includes(:translation_key).where(locale: locale).inject({}) do |memo, t|
      memo[t.translation_key.key] = t.text if t.translation_key
      memo
    end
  end
end
