class Office::RegistrationsController < Office::ApplicationController
  before_filter :event
  before_filter :registration, only: [:edit, :update, :show, :destroy]

  def edit
    store_location(params[:back_url])
  end

  def update
    if registration.update_attributes(params[:registration])
      redirect_to(back_url, :notice => 'Registration was successfully updated.')
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    registration.destroy
    redirect_to(back_url, :notice => 'Registration was successfully deleted.')
  end

  private

  def registration
    @registration ||= event.registrations.find(params[:id])
  end

  def back_url
    stored_location || office_event_registrations_url(event)
  end

  def event
    @event ||= Event.find(params[:event_id])
  end

  def registrations
    event.registrations.by_first_name
  end
  helper_method :registrations

  def non_registrations
    registrations.pending
  end
  helper_method :non_registrations
end
