class Office::DashboardsController < Office::ApplicationController
  def index
    @pending = PublicSignup.pending
    @waitlisted = PublicSignup.waitlisted
    @events = Event.current.first(2)
  end
end
