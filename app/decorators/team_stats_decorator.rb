class TeamStatsDecorator < Draper::Decorator
  FIELDS = [:male, :female, :total]
  EXTRA_FIELDS = [:desired, :delta]

  def fields
    FIELDS
  end

  def extra_fields
    @extra_fields ||= (object.counts(:team).keys - FIELDS - EXTRA_FIELDS).sort + EXTRA_FIELDS
  end

  def headings(fields)
    fields.map { |field| field.to_s.humanize }
  end

  def counts(fields, group)
    fields.map { |field| object.counts(group)[field] }
  end

  def full?
    delta >= 0
  end

  def delta
    object.counts(:team)[:delta]
  end

  def delta_with_symbol
    full? ? "+ #{delta}" : delta
  end
end
