class MemberDecorator < Draper::Decorator
  delegate :full_name, :role, :notes, :team, :id

  def summary
    [status, notes].compact.join('. ')
  end

  def status
    object.status unless object.status == Membership::EXPERIENCED
  end

  def created_at
    h.localize(object.created_at.to_date, format: :sortable)
  end

  def gender
    object.gender.first
  end

  def hai_workshops_on_team_count
    object.membership.hai_workshops_team_registrations.count
  end

  def highest_level
    object.angel.highest_level if team.event.level && object.angel.highest_level < team.event.level
  end

  def most_recent_on_team_date
    registration = object.membership.hai_workshops_team_registrations.first
    h.time_ago_in_words(registration.start_date) if registration
  end
end
