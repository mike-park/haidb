class Office::DashboardsController < Office::ApplicationController
  def index
    @last_event = Event.past.first
    @upcoming_events = Event.upcoming
  end
end
