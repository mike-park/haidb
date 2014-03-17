class Users::DashboardsController < Users::SignedInController
  def index
    @registrations = {
        upcoming: upcoming_registrations,
        past: past_registrations
    }
  end

  private

  def upcoming_registrations
    current_user.registrations.upcoming_events.by_start_date_asc
  end

  def past_registrations
    current_user.registrations.past_events.by_start_date
  end
end