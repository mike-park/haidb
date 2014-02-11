class MembershipDecorator < Draper::Decorator
  delegate_all

  def participant_cost
    h.local_currency(membership.participant_cost)
  end

  def team_cost
    h.local_currency(membership.team_cost)
  end

  def active_on
    h.localize(membership.active_on) if membership.active_on
  end

  def retired_on
    h.localize(membership.retired_on) if membership.retired_on
  end
end
