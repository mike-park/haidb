class Event < ActiveRecord::Base
  audited

  LIS = 'HAI LIS Workshop'
  TEAM = 'Team Workshop'
  COMMUNITYWEEKEND = 'Community Weekend'
  HANDONHEART = 'Hand-on-Heart Workshop'
  OTHER = 'Other'
  CATEGORIES = [LIS, TEAM,
                COMMUNITYWEEKEND, HANDONHEART, OTHER]

  store :options, accessors: [:next_registration_code]

  has_many :registrations, :inverse_of => :event, :dependent => :destroy
  has_many :completed_registrations, -> { where(completed: true) }, class_name: 'Registration'
  has_many :angels, :through => :registrations
  has_many :completed_angels, through: :completed_registrations, source: :angel

  has_many :event_emails, :dependent => :destroy
  has_many :email_names, -> { distinct }, :through => :event_emails

  scope :with_oldest_last, -> {order('start_date desc')}
  scope :past, -> { order('start_date desc').where('start_date < ?', Date.today) }
  scope :upcoming, lambda { order('start_date asc').where('start_date >= ?', Date.today)}
  scope :current, lambda { order('start_date asc').where('start_date >= ?', Date.today - 1.week)}

  validates_presence_of :display_name, :category, :start_date
  validates_inclusion_of :category, :in => CATEGORIES
  validates_numericality_of :next_registration_code, :participant_cost, :team_cost, allow_blank: true, allow_nil: true,
                            greater_than_or_equal_to: 0
  before_validation :reset_next_registration_code, if: lambda { |e| e.next_registration_code.blank? }
  after_save :update_highest_level

  accepts_nested_attributes_for :event_emails

  def email_name(email_category)
    find_event_email(email_category).try(:name)
  end

  def email(email_category, locale)
    find_event_email(email_category).try(:email, locale)
  end

  def find_event_email(email_category)
    event_emails.with_category(email_category).first
  end

  def upcoming?
    start_date > Date.today
  end

  def past?
    !upcoming?
  end

  def claim_registration_code
    if has_registration_codes?
      code = next_registration_code
      update_attribute(:next_registration_code, code.next)
      code
    end
  end

  def cost_for(role)
    case role
      when Registration::TEAM
        team_cost
      when Registration::PARTICIPANT
        participant_cost
      else
        0
    end
  end

  def has_registration_codes?
    next_registration_code.present?
  end

  def participants
    registrations.participants
  end

  private

  def update_highest_level
    angels.each(&:cache_highest_level) if changed.include?('level')
  end

  def reset_next_registration_code
    self.next_registration_code = nil
  end
end
