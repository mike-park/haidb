class MemberDecorator < Draper::Decorator
  delegate :full_name, :role, :notes, :team, :id

  def status
    object.status unless object.status == Membership::EXPERIENCED
  end

  def highest_level
    object.angel.highest_level
  end

  def most_recently_on_team
    registration = object.membership.on_team.first
    registration ? "#{h.time_ago_in_words(registration.start_date)} ago" :  'Never'
  end

  def summary
    [status, "#{most_recently_on_team} on team", notes].reject(&:blank?).join(', ')
  end
end
