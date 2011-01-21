class Office::Registrations::CheckedInController < Office::RegistrationsController
  def index
  end
  
  # mark all registrations as checked_in=true if all=checked_in, otherwise
  # checked_in=false
  def create
    value = params[:all] == 'checked_in'
    registrations.each { |r| r.update_attribute(:checked_in, value) }
    redirect_to(office_event_checked_in_index_url(event))
  end

  # toggle value of completed attribute
  def update
    registration.update_attribute(:checked_in, !registration.checked_in)
    redirect_to(office_event_checked_in_index_url(event))
  end
end
