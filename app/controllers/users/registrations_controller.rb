class Users::RegistrationsController < Users::SignedInController
  def index
    @registrations = registrations
  end

  private

  def registrations
    current_user.registrations.includes(:event).by_start_date
  end
end