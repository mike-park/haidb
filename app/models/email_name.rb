class EmailName < ActiveRecord::Base
  has_many :emails, :dependent => :destroy

  has_many :event_emails, :dependent => :destroy
  has_many :events, -> { distinct }, :through => :event_emails

  scope :by_name, -> { order('name asc') }

  validates_presence_of :name

  accepts_nested_attributes_for :emails

  def add_missing_locales
    missing_locales = Site.available_locales - available_locales
    missing_locales.each do |locale|
      emails.build(locale: locale)
    end
    self
  end
  
  def email(locale)
    emails.find_by_locale(locale)
  end

  private

  def available_locales
    emails.map(&:locale)
  end
end