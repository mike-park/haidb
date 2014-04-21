class Office::EventsController < Office::ApplicationController
  def index
    @events = Event.upcoming
  end

  def past
    @events = Event.past
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to([:office, @event], :notice => 'Event was successfully created.')
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to([:office, @event], :notice => 'Event was successfully updated.')
    else
      render :edit
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to(office_events_url, :notice => 'Event was successfully deleted.')
  end

  def completed
    event = Event.find(params[:id])
    event.registrations.each(&:toggle_completed)
    redirect_to(completed_office_event_report_path(event), notice: 'Toggled event')
  end

  private

  def event_params
    params.require(:event).permit!
  end
end
