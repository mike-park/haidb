class PublicSignup < ActiveRecord::Base
  audited

  has_one :registration, :inverse_of => :public_signup, :dependent => :destroy
  
  attr_accessor :terms_and_conditions

  default_scope -> { includes(:registration) }
  scope :pending, -> { where(registrations: {status: Registration::PENDING}) }
  scope :waitlisted, -> { where(registrations: {status: Registration::WAITLISTED}) }
  scope :approved, -> { where(registrations: {status: Registration::APPROVED}) }
  scope :by_created_at, -> { order('public_signups.created_at asc') }

  accepts_nested_attributes_for :registration

  validates_acceptance_of :terms_and_conditions, allow_nil: false, on: :create

  delegate :full_name, :event_name, :gender, :email, :lang, :angel, :send_email, :reg_fee_received, :clothing_conversation, :to => :registration

  def self.group_by_event
    events = by_created_at.inject({}) do |memo, public_signup|
      event = public_signup.registration.event
      memo[event] ||= []
      memo[event] << public_signup
      memo
    end
    events.keys.sort {|a, b| a.start_date <=> b.start_date }.map {|event| events[event] }
  end

  # marks this signup and the embedded registration as approved
  def approve!
    self.approved_at = Time.now
    registration.approve
    save!
  end

  def waitlist!
    registration.waitlist
    save!
  end

  def display_name
    full_name
  end
end
