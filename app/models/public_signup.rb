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
  has_one :registration, :inverse_of => :public_signup, :dependent => :destroy
  
  attr_accessor :terms_and_conditions

  default_scope includes(:registration => [ :angel ])
  scope :pending, where(:approved_at => nil)
  scope :approved, where("public_signups.approved_at is NOT NULL")
  scope :by_created_at, order('public_signups.created_at asc')

  accepts_nested_attributes_for :registration

  validates_acceptance_of :terms_and_conditions, { :on => :create }

  # marks this signup as approved and sends confirmation email to person
  def set_approved!
    self.approved_at = Time.now
    registration.approved = true
    save!
    logger.debug "#{registration.id} approved.  send email to #{registration.angel.email}"
  end

  def full_name
    registration.angel.full_name
  end
  alias :display_name :full_name

  def event_name
    registration.event.display_name
  end

  def gender
    registration.angel.gender
  end

  def approved?
    registration.approved?
  end
end
