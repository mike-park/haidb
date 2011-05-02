# == Schema Information
# Schema version: 20110320131630
#
# Table name: public_signups
#
#  id          :integer         primary key
#  ip_addr     :string(255)
#  created_at  :timestamp
#  updated_at  :timestamp
#  approved_at :timestamp
#

class PublicSignup < ActiveRecord::Base
  acts_as_audited
  after_initialize :setup_registration
  
  has_one :registration, :inverse_of => :public_signup, :dependent => :destroy
  
  attr_accessor :terms_and_conditions

  WAITLISTED = 'waitlisted'
  APPROVED = 'approved'
  PENDING = 'pending'
  STATUSES = [PENDING, WAITLISTED, APPROVED]

  default_scope includes(:registration => [ :angel ])
  scope :pending, where("public_signups.status = ?", PENDING)
  scope :waitlisted, where("public_signups.status = ?", WAITLISTED)
  scope :approved, where("public_signups.status = ?", APPROVED)
  scope :by_created_at, order('public_signups.created_at asc')

  accepts_nested_attributes_for :registration

  validates_acceptance_of :terms_and_conditions, { :on => :create }
  validates_inclusion_of :status, :in => STATUSES

  delegate :full_name, :event_name, :gender, :email, :lang,
  :angel, :to => :registration

  STATUSES.each do |state|
    define_method("#{state}?") do
      !!(status == state)
    end
  end

  # marks this signup and the embedded registration as approved
  def set_approved!
    self.approved_at = Time.now
    self.status = APPROVED
    registration.approved = true
    save!
    Angel.merge_and_delete_duplicates_of(angel)
  end

  def set_waitlisted!
    self.status = WAITLISTED
    save!
  end

  def display_name
    full_name
  end

  private

  # ensure we have necessary sub objects
  def setup_registration
    unless registration
      build_registration
      registration.build_angel
    end
  end
  
end
