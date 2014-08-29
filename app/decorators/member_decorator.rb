class MemberDecorator < Draper::Decorator
  delegate :full_name, :role, :notes, :team, :id

  def status
    object.status unless object.status == Membership::EXPERIENCED
  end

  def created_at
    h.localize(object.created_at.to_date, format: :sortable)
  end

  def gender
    object.gender.first
  end

  def total_on_team
    object.membership.on_team.count
  end

  def highest_level
    object.angel.highest_level if team.event.level && object.angel.highest_level < team.event.level
  end

  def last_team_date
    registration = object.membership.on_team.first
    h.time_ago_in_words(registration.start_date) if registration
  end
end
