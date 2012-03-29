class Event < ActiveRecord::Base
  acts_as_audited

  LIS = 'HAI LIS Workshop'
  TEAM = 'Team Workshop'
  COMMUNITYWEEKEND = 'Community Weekend'
  HANDONHEART = 'Hand-on-Heart Workshop'
  OTHER = 'Other'
  CATEGORIES = [LIS, TEAM,
                COMMUNITYWEEKEND, HANDONHEART, OTHER]

  has_many :registrations, :inverse_of => :event, :dependent => :destroy
  has_many :angels, :through => :registrations

  has_many :event_emails, :dependent => :destroy
  has_many :email_names, :through => :event_emails, :uniq => true

  scope :with_oldest_last, order('start_date desc')
  scope :upcoming, lambda { order('start_date asc').where('start_date > ?', Date.today)}

  validates_presence_of :display_name, :category, :start_date
  validates_inclusion_of :category, :in => CATEGORIES

  accepts_nested_attributes_for :event_emails

  def email_name(email_category)
    find_event_email(email_category).try(:name)
  end

  def email(email_category, locale)
    find_event_email(email_category).try(:email, locale)
  end

  def find_event_email(email_category)
    event_emails.find_by_category(email_category)
  end

  def upcoming?
    start_date > Date.today
  end

  def past?
    !upcoming?
  end
end



# == Schema Information
#
# Table name: events
#
#  id           :integer         not null, primary key
#  display_name :string(255)     not null
#  category     :string(255)     not null
#  level        :integer         default(0)
#  start_date   :date            not null
#  created_at   :datetime
#  updated_at   :datetime
#

