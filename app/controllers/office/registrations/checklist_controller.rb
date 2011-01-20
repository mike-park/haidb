class Office::Registrations::ChecklistController < Office::RegistrationsController
  respond_to :html, :pdf
  def index
    respond_with(registrations)
  end
end
