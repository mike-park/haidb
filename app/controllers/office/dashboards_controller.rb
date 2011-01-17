class Office::DashboardsController < Office::ApplicationController
  def index
    @pending = PublicSignup.pending
    @events = Event.upcoming.first(2)
  end
end
