# == Schema Information
# Schema version: 20110114122352
#
# Table name: registrations
#
#  id                :integer         not null, primary key
#  angel_id          :integer         not null
#  event_id          :integer         not null
#  role              :string(255)     not null
#  special_diet      :boolean
#  backjack_rental   :boolean
#  sunday_stayover   :boolean
#  sunday_meal       :boolean
#  sunday_choice     :string(255)
#  lift              :string(255)
#  payment_method    :string(255)
#  bank_account_nr   :string(255)
#  bank_account_name :string(255)
#  bank_name         :string(255)
#  bank_sort_code    :string(255)
#  notes             :text
#  completed         :boolean
#  checked_in        :boolean
#  created_at        :datetime
#  updated_at        :datetime
#  public_signup_id  :integer
#  approved          :boolean
#

class Registration < ActiveRecord::Base
  before_save SundayChoiceCallbacks
  after_destroy :destroy_public_signup

  # role types
  PARTICIPANT = 'Participant'
  FACILITATOR = 'Facilitator'
  TEAM = 'Team'
  ROLES = [PARTICIPANT, FACILITATOR, TEAM]

  OFFERED = 'Offered'
  REQUESTED = 'Requested'
  LIFTS = [OFFERED, REQUESTED]

  # payment methods. if internet the bank fields are required
  INTERNET = 'Internet'
  POST = 'Post'
  DIRECT = 'Direct'
  PAYMENT_METHODS = [INTERNET, POST, DIRECT]
  
  MEAL = "Meal"
  STAYOVER = "Stayover"
  SUNDAY_CHOICES = [MEAL, STAYOVER]

  belongs_to :angel, :inverse_of => :registrations
  belongs_to :event, :inverse_of => :registrations
  belongs_to :public_signup, :inverse_of => :registration

  accepts_nested_attributes_for :angel

  # XXX verify we need angel and action
  #attr_accessor :angel, :action

  scope :ok, includes([:angel, :event]).where(:approved => true)
  scope :pending, where(:approved => false)

  scope :team, where(:role => TEAM)
  scope :participants, where(:role => PARTICIPANT)
  scope :facilitators, where(:role => FACILITATOR)
  
  scope :special_diets, where(:special_diet => true)
  scope :backjack_rentals, where(:backjack_rental => true)
  scope :sunday_stayovers, where(:sunday_stayover => true)
  scope :sunday_meals, where(:sunday_meal => true)
  scope :females, where(:angels => {:gender => Angel::FEMALE})
  scope :males, where(:angels => {:gender => Angel::MALE})
  scope :by_first_name, order('LOWER(angels.first_name) asc')
  scope :by_start_date, order('events.start_date desc')
  scope :completed, where(:completed => true)

  validates_uniqueness_of :angel_id, {
    :scope => :event_id,
    :message => 'already registered for this event'
  }

  validates_presence_of :angel
  validates_presence_of :event, {
    :message => :select
  }

  validates_inclusion_of :role, {
    :in => ROLES, :message => :select
  }

  validates_inclusion_of :sunday_choice, {
    :in => SUNDAY_CHOICES,
    :unless => "sunday_choice.blank?"
  }

  validates_presence_of :bank_account_nr, :bank_account_name,
  :bank_name, :bank_sort_code, {
    :if => "payment_method == INTERNET"
  }

  validates_inclusion_of :payment_method, {
    :in => PAYMENT_METHODS,
    :message => :select
  }
  
  validates_inclusion_of :lift, {
    :in => LIFTS,
    :unless => "lift.blank?"
  }

  delegate :level, :to => :event
  delegate :full_name, :gender, :lang, :email, :to => :angel
  
  def event_name
    event.display_name
  end

  def self.highest_level(angel)
    maximum('events.level', :include => :event, :conditions => {
              :approved => true,
              :completed => true,
              :angel_id => angel.id
            }).to_i
  end

  def display_name
    "#{event_name} registration of #{full_name}"
  end

  def destroy_public_signup
    public_signup.destroy if public_signup
  end
  
end
