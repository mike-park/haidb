class Office::CompletedRegistrationsController < Office::ApplicationController
  before_filter :find_event
  
  def index
  end
  
  def create
    value = params[:all] == 'completed'
    registrations.each { |r| r.update_attribute(:completed, value) }
    redirect_to(office_event_completed_registrations_url(event),
                  :notice => 'Registrations updated.')
  end

  def update
    registration.update_attribute(:completed, !registration.completed)
    redirect_to(office_event_completed_registrations_url(event),
                  :notice => 'Registration updated.')
  end

  protected

  def find_event
    unless event
      logger.warn "completed_registrations_controller without event: #{params}"
      redirect_to(office_events_url, :alert => 'You must select an event first')
    end
  end

  def parent
    @parent ||= event
  end
  helper_method :parent
  hide_action :parent
  
  def event
    @event ||= Event.find_by_id(params[:event_id])
  end
  helper_method :event
  hide_action :event
  
  def registrations
    @registrations ||= event.registrations.ok
  end
  helper_method :registrations
  hide_action :registrations
  
  # return current registration, its ok to return nil
  def registration
    @registration ||= registrations.find_by_id(params[:id])
  end
  helper_method :registration
  hide_action :registration
  
end
