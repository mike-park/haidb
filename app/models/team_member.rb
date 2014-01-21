class TeamMember < SimpleDelegator
  def self.team_members_since(date)
    (on_team_angels_since(date) + in_team_workshop_angels_since(date)).sort.uniq.map { |angel| new(angel) }
  end

  def eql?(other)
    id.eql?(other.id)
  end

  def ==(other)
    eql?(other)
  end

  def on_team
    registrations.team.completed.by_start_date
  end

  def team_workshops
    registrations.non_facilitators.completed.team_workshops.by_start_date
  end

  def on_team_or_team_workshops
    (on_team + team_workshops).sort.uniq
  end
  private

  def self.on_team_angels_since(date)
    Registration.team.completed.since(date).map(&:angel)
  end

  def self.in_team_workshop_angels_since(date)
    Registration.ok.team_workshops.completed.since(date).map(&:angel)
  end
end