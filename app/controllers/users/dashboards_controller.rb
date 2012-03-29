class Users::DashboardsController < Users::ApplicationController
  def index
    registrations = Registration.where_email(current_user.email)
    @pending = registrations.pending.upcoming_events.by_start_date_asc
    @approved = registrations.ok.by_start_date
  end
end