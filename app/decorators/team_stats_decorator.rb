class TeamStatsDecorator < Draper::Decorator
  FIELDS = [:male, :female, :total, :desired, :delta]

  def headings
    FIELDS.map { |field| field.to_s.humanize }
  end

  def counts(group)
    FIELDS.map { |field| object.counts(group, field) }
  end

  def full?
    delta >= 0
  end

  def delta
    object.counts(:team, :delta)
  end

  def delta_with_symbol
    full? ? "+ #{delta}" : delta
  end
end
