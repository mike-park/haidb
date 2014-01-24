class PublicSignup < ActiveRecord::Base
  acts_as_audited

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

  validates_acceptance_of :terms_and_conditions, allow_nil: false, on: :create
  validates_inclusion_of :status, :in => STATUSES

  delegate :full_name, :event_name, :gender, :email, :lang, :angel, :send_email, :reg_fee_received, :clothing_conversation, :to => :registration

  STATUSES.each do |state|
    define_method("#{state}?") do
      !!(status == state)
    end
  end

  # marks this signup and the embedded registration as approved
  def approve!
    transaction do
      self.approved_at = Time.now
      self.status = APPROVED
      registration.approve!
      save!
    end
    Angel.merge_and_delete_duplicates_of(angel)
  end

  def set_waitlisted!
    self.status = WAITLISTED
    registration.approved = false
    save!
  end

  def display_name
    full_name
  end
end
