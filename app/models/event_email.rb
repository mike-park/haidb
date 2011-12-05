class EventEmail < ActiveRecord::Base
  SIGNUP = "Signup"
  PENDING = "Pending"
  APPROVED = "Approved"
  CATEGORIES = [SIGNUP, PENDING, APPROVED]

  belongs_to :email_name
  belongs_to :event

  validates_presence_of :category
  validates_inclusion_of :category, :in => CATEGORIES
  validates_uniqueness_of :category, :scope => :event_id

  delegate :name, :email, :to => :email_name, :allow_nil => true
end


# == Schema Information
#
# Table name: event_emails
#
#  id            :integer         not null, primary key
#  email_name_id :integer
#  event_id      :integer
#  category      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

