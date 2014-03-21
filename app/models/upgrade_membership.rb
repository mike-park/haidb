class UpgradeMembership
  def initialize(membership)
    @membership = membership
    @changed = false
  end

  def invoke
    if aws? && on_team?
      status(Membership::PRELIMINARY)
    end
    if novice? && on_team >= 4
      status(Membership::EXPERIENCED)
    end
    @changed
  end

  private

  def status(value)
    @membership.update_attribute(:status, value)
    @changed = true
  end

  def aws?
    @membership.status == Membership::AWS
  end

  def novice?
    @membership.status == Membership::NOVICE
  end

  def on_team
    @membership.on_team.count
  end

  def on_team?
    on_team > 0
  end
end