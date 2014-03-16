class Membership < ActiveRecord::Base
  acts_as_audited
  include Csvable

  csv_fields :full_name, :email, :status, :active_on, :retired_on

  belongs_to :angel
  store :options, accessors: []

  # AWS = only AWS
  # Preliminary = Still in tryout phase
  # Novice = Accepted and less than X workshops
  # Experienced = >= X workshops
  # TeamCo = duh
  STATUSES = [AWS='AWS/TWS', PRELIMINARY='Preliminary', NOVICE='Novice', EXPERIENCED='Experienced', TEAMCO='TeamCo']

  scope :active, lambda { where(retired_on: nil).where('active_on <= ?', Date.current) }
  scope :retired, lambda { where('retired_on <= ?', Date.current) }

  validates_presence_of :angel
  validates_inclusion_of :status, {
      :in => STATUSES, :message => :select
  }
  validates_uniqueness_of :angel_id, scope: :retired_on, if: lambda { |m| m.retired_on.nil? }

  delegate :full_name_with_context, :<=>, :full_name, :email, :highest_level, :registrations, to: :angel

  # registrations

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
