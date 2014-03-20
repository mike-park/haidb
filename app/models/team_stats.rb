class TeamStats
  def initialize(team)
    @team = team
  end

  def counts(group)
    totals[group]
  end

  def to_partial_path
    "team_stats"
  end

  private

  def totals
    @totals ||= {
        team: team_totals,
        participants: participant_totals
    }
  end

  def team_totals
    tt = total_for(@team.members)
    tt[:desired] = @team.desired_size || 0
    tt[:delta] = tt[:total] - tt[:desired]
    tt.merge!(word_counts(@team.members.map(&:status).compact))
    tt.merge!(word_counts(@team.members.map(&:role).reject {|w| w.blank?}))
    tt
  end

  def word_counts(words)
    words.inject({}) do |memo, word|
      memo[word] ||= 0
      memo[word] += 1
      memo
    end
  end

  def participant_totals
    @team.event ? total_for(@team.event.participants) : {}
  end

  def total_for(object)
    females = object.females.count
    males = object.males.count
    {
        female: females,
        male: males,
        total: females + males
    }
  end
end
