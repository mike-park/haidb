# == Schema Information
# Schema version: 20101208075331
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

class Event < ActiveRecord::Base
  LIS = 'HAI LIS Workshop'
  TEAM = 'Team Workshop'
  COMMUNITYWEEKEND = 'Community Weekend'
  HANDONHEART = 'Hand-on-Heart Workshop'
  OTHER = 'Other'
  CATEGORIES = [LIS, TEAM,
                COMMUNITYWEEKEND, HANDONHEART, OTHER]

  has_many :registrations, :inverse_of => :event, :dependent => :destroy
  has_many :angels, :through => :registrations

  scope :with_oldest_last, order('start_date desc')
  scope :upcoming, lambda { order('start_date asc').where('start_date > ?', Date.today)}

  validates_presence_of :display_name, :category, :start_date
  validates_inclusion_of :category, :in => CATEGORIES

end
