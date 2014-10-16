class Membership < ActiveRecord::Base
  audited
  include Csvable

  csv_fields :full_name, :email, :status, :active_on, :retired_on

  belongs_to :angel
  has_many :members, inverse_of: :membership

  store :options, accessors: [:default_role]

  # Provisional = Still in tryout phase
  # Novice = Accepted and less than X workshops
  # Experienced = >= X workshops
  STATUSES = [PROVISIONAL='Provisional', NOVICE='Novice', EXPERIENCED='Experienced']
  ROLES = Member::ROLES

  scope :active, lambda { where(retired_on: nil) }
  scope :retired, lambda { where('retired_on IS NOT NULL') }
  scope :with_gender, ->(gender) { joins(:angel).where(angels: {gender: gender}) }
  scope :by_full_name, -> { joins(:angel).order('angels.first_name, angels.last_name asc') }
  scope :by_active_on_desc, -> { order('active_on desc') }

  validates_presence_of :angel, :active_on
  validates_inclusion_of :status, {
      :in => STATUSES, :message => :select
  }
  validates_inclusion_of :default_role, {
      :in => ROLES, :message => :select, allow_blank: true, allow_nil: true
  }
  validates_uniqueness_of :angel_id, scope: :retired_on, message: 'Already has an active membership',
                          if: lambda { |m| m.retired_on.nil? }

  delegate :<=>, :full_name, :email, :highest_level, :registrations, to: :angel

  def self.move_to(angel, ids)
    return unless ids.any?

    memberships = where(id: ids).by_active_on_desc.to_a
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

  def self.upgrade_memberships
    active.select(&:upgrade_membership)
  end

  def upgrade_membership
    if status == NOVICE && hai_workshops_team_registrations.count > 4
      update_attribute(:status, EXPERIENCED)
    end
  end

  def full_name_with_context
    "#{full_name} - #{status}"
  end

  def retired?
    !!retired_on
  end

  def hai_workshops_team_registrations
    registrations.completed.hai_workshops.non_participants.by_start_date
  end

  def team_workshops_registrations
    registrations.completed.team_workshops.by_start_date
  end

  def team_registrations
    (hai_workshops_team_registrations + team_workshops_registrations).sort.uniq
  end
end
