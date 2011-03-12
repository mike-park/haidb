# == Schema Information
# Schema version: 20110114122352
#
# Table name: public_signups
#
#  id          :integer         not null, primary key
#  ip_addr     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  approved_at :datetime
#

class PublicSignup < ActiveRecord::Base
  acts_as_audited
  after_initialize :setup_registration
  
  has_one :registration, :inverse_of => :public_signup, :dependent => :destroy
  
  attr_accessor :terms_and_conditions

  default_scope includes(:registration => [ :angel ])
  scope :pending, where(:approved_at => nil)
  scope :approved, where("public_signups.approved_at is NOT NULL")
  scope :by_created_at, order('public_signups.created_at asc')

  accepts_nested_attributes_for :registration

  validates_acceptance_of :terms_and_conditions, { :on => :create }

  delegate :full_name, :event_name, :gender, :approved?, :email, :lang,
  :to => :registration
  
  # marks this signup and the embedded registration as approved
  def set_approved!
    self.approved_at = Time.now
    registration.approved = true
    save!
    registration.angel.merge_and_delete_duplicates
  end

  def display_name
    registration.full_name
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
