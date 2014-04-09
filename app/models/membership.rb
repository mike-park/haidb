class Membership < ActiveRecord::Base
  acts_as_audited
  include Csvable

  csv_fields :full_name, :email, :status, :active_on, :retired_on

  belongs_to :angel
  has_many :members, inverse_of: :membership

  store :options, accessors: []

  # AWS = only AWS
  # Preliminary = Still in tryout phase
  # Novice = Accepted and less than X workshops
  # Experienced = >= X workshops
  # TeamCo = duh
  STATUSES = [AWS='AWS/TWS', PRELIMINARY='Preliminary', NOVICE='Novice', EXPERIENCED='Experienced', TEAMCO='TeamCo',
              FACILITATOR='Facilitator']

  scope :active, lambda { where(retired_on: nil) }
  scope :retired, lambda { where('retired_on IS NOT NULL') }
  scope :with_gender, ->(gender) { includes(:angel).where(angels: {gender: gender}) }
  scope :by_full_name, -> { includes(:angel).order('angels.first_name, angels.last_name asc') }
  scope :by_active_on_desc, -> { order('active_on desc') }

  validates_presence_of :angel, :active_on
  validates_inclusion_of :status, {
      :in => STATUSES, :message => :select
  }
  validates_uniqueness_of :angel_id, scope: :retired_on, message: 'Already has an active membership',
                          if: lambda { |m| m.retired_on.nil? }

  delegate :<=>, :full_name, :email, :highest_level, :registrations, to: :angel

  def self.move_to(angel, ids)
    return unless ids.any?

    memberships = where(id: ids).by_active_on_desc
    most_recent_membership = memberships.shift
    retired_on = most_recent_membership.active_on || Date.current
    memberships.each do |membership|
      membership.retired_on ||= retired_on
      membership.angel = angel
      membership.save!
      retired_on = membership.active_on || Date.current
    end
    most_recent_membership.angel = angel
    most_recent_membership.save!
  end

  def self.recalc_status
    active.select(&:recalc_status)
  end

  def recalc_status
    UpgradeMembership.new(self).invoke
  end

  def full_name_with_context
    "#{full_name} - #{status}"
  end

  def retired?
    !!retired_on
  end

  def on_team
    registrations.completed.team.by_start_date
  end

  def team_workshops
    registrations.completed.team_workshops.by_start_date
  end

  def on_team_or_team_workshops
    (on_team + team_workshops).sort.uniq
  end
end
