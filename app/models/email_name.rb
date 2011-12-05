class EmailName < ActiveRecord::Base
  has_many :emails, :dependent => :destroy

  has_many :event_emails, :dependent => :destroy
  has_many :events, :through => :event_emails, :uniq => true

  validates_presence_of :name

  accepts_nested_attributes_for :emails, :allow_destroy => true,
                                :reject_if => lambda {|attr| attr['subject'].blank? && attr['body'].blank? }

  def add_missing_locales
    missing_locales = I18n.available_locales - available_locales
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


# == Schema Information
#
# Table name: email_names
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

