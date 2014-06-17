class EventEmail < ActiveRecord::Base
  SIGNUP = 'Signup'
  PENDING = 'Pending'
  APPROVED = 'Approved'
  CATEGORIES = [SIGNUP, PENDING, APPROVED, UPCOMING_DIRECT_DEBIT='Upcoming Direct Debit']

  belongs_to :email_name
  belongs_to :event

  validates_presence_of :category
  validates_inclusion_of :category, :in => CATEGORIES
  validates_uniqueness_of :category, :scope => :event_id

  scope :with_category, ->(category) { where(category: category) }

  delegate :name, :email, :to => :email_name, :allow_nil => true
end