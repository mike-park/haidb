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

  def emails
    registrations.map {|r| r.email }
  end

  def has_email?(email)
    emails.include?(email)
  end

  # -> "roster"
  def to_partial_path
    self.class.to_s.downcase
  end
end