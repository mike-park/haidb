class Office::RegistrationsController < Office::ApplicationController
  before_filter :event_or_angel
  
  def roster
    respond_to do |format|
      format.html # roster.html.haml
      #format.pdf  { render :layout => false }
    end
  end

  def new
    @registration = registrations.new(params[:registration])
  end
    
  def create
    @registration = registrations.new(params[:registration])
    @registration.approved = true
    if @registration.save
      redirect_to([:office, parent, :registrations],
                  :notice => 'Registration was successfully created.')
    else
      render :new
    end
  end

  def update
    if registration.update_attributes(params[:registration])
      redirect_to([:office, parent, :registrations],
                  :notice => 'Registration was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    registration.destroy
    redirect_to([:office, parent, :registrations],
                :notice => 'Registration was successfully deleted.')
  end
  

  protected

  def event_or_angel
    unless parent
      logger.warn "registrations_controller without event or angel: #{params}"
      redirect_to(office_events_url, :alert => 'You must select an event first')
    end
  end

  def parent
    @parent ||= event || angel
  end
  helper_method :parent
  hide_action :parent
  
  def event
    @event ||= Event.find_by_id(params[:event_id])
  end
  helper_method :event
  hide_action :event
  
  def angel
    @angel ||= Angel.find_by_id(params[:angel_id])
  end
  helper_method :angel
  hide_action :angel
  
  def registrations
    @registrations ||= parent.registrations.ok
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
