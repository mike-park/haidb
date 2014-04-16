class Office::EventsController < Office::ApplicationController
  before_filter :find_event, :except => [:index, :past, :new, :create]
  
  def index
    find_events_where("start_date > ?", Date.current, "start_date.asc")
  end

  def past
    find_events_where("start_date < ?", Date.tomorrow, "start_date.desc")
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])

    if @event.save
      redirect_to([:office, @event], :notice => 'Event was successfully created.')
    else
      render :new
    end
  end

  def update
    if event.update_attributes(params[:event])
      redirect_to([:office, event], :notice => 'Event was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    event.destroy
    redirect_to(office_events_url, :notice => 'Event was successfully deleted.')
  end

  def completed
    @event.registrations.each(&:toggle_completed)
    redirect_to(completed_office_event_report_path(@event), notice: 'Toggled event')
  end

  protected

  def find_events_where(where1, where2, orderby)
    params[:q] ||= {}
    params[:q][:meta_sort] ||= orderby
    params[:rows] ||= 10
    @q = Event.where(where1, where2).search(params[:q])
    @events = @q.result.paginate(:page => params[:page], :per_page => params[:rows])
  end

  def find_event
    unless event
      redirect_to(office_events_url, :alert => 'You must select an event first.')
    end
  end

  def registrations
    @registrations ||= event.registrations.ok.by_first_name
  end
  helper_method :registrations

  def event
    @event ||= Event.find_by_id(params[:id])
  end
  helper_method :event
end
