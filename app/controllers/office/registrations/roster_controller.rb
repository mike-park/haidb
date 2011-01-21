class Office::Registrations::RosterController < Office::RegistrationsController
  respond_to :html, :pdf
  def index
    respond_with(registrations)
  end
end
