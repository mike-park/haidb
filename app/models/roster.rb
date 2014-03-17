class Roster
  def self.find(*args)
    Roster.new(Event.find(*args))
  end

  def initialize(event)
    @event = event
  end

  def registrations
    @event.completed_registrations
  end

  def name
    @event.display_name
  end

  def has_angel?(angel)
    angels.include?(angel)
  end

  # -> "roster"
  def to_partial_path
    self.class.to_s.downcase
  end

  private

  def angels
    registrations.map(&:angel)
  end
end