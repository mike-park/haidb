class Office::DashboardsController < Office::ApplicationController
  def index
    @pending = PublicSignup.pending
    @waitlisted = PublicSignup.waitlisted
    @events = Event.upcoming.first(2)
  end
end
