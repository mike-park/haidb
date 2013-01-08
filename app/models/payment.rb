class Payment < ActiveRecord::Base
  acts_as_audited
  belongs_to :registration
  attr_accessible :amount, :note, :paid_on

  validates_presence_of :paid_on, :amount
  validates_numericality_of :amount

  scope :by_date, -> { order('paid_on desc') }

  after_save :update_summary
  after_destroy :update_summary

  private

  def update_summary
    registration.update_payment_summary!
  end
end
