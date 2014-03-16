class Office::RegistrationsController < Office::ApplicationController
  before_filter :find_event_or_angel

  def index
    respond_to do |format|
      format.html
      format.csv { send_data Registration.to_csv(registrations.ok), filename: "#{event.display_name}.csv", type: :csv }
      format.vcard { send_data Registration.to_vcard(registrations.ok), filename: "#{event.display_name}.vcf", type: :vcard }
    end
  end

  def new
    @registration = registrations.new(params[:registration])
  end

  def create
    @registration = registrations.new(params[:registration])
    @registration.approved = true
    if @registration.save
      redirect_to(back_url, :notice => 'Registration was successfully created.')
    else
      render :new
    end
  end

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

  def destroy
    registration.destroy
    redirect_to(back_url, :notice => 'Registration was successfully deleted.')
  end


  def checklists
    @title = "#{event.display_name} Checklist"
    respond_to do |format|
      format.html
      format.pdf do
        send_data render_to_string(:layout => false), {
            :filename => "#{event.display_name} checklist.pdf",
            :type => :pdf,
        }
      end
    end
  end

  def roster
    @roster = RosterDecorator.new(Roster.new(event))
    respond_to do |format|
      format.html
      format.pdf { send_data(@roster.to_pdf, filename: @roster.filename, type: :pdf) }
    end
  end

  protected

  def verify_registration_exists
    unless registration
      redirect_to(back_url, alert: 'Unknown registration selected')
    end
  end

  def back_url
    stored_location || parent.index_url
  end

  def find_event_or_angel
    unless parent
      redirect_to(office_events_url, :alert => 'You must select an event first')
    end
  end

  def parent
    @parent ||= begin
      if (event = Event.find_by_id(params[:event_id]))
        EventParent.new(event, self)
      elsif (angel = Angel.find_by_id(params[:angel_id]))
        AngelParent.new(angel, self)
      end
    end
  end
  helper_method :parent

  def registrations
    parent.registrations.ok
  end
  helper_method :registrations

  def non_registrations
    parent.registrations.pending
  end
  helper_method :non_registrations

  def angels
    parent.angels
  end
  helper_method :angels

  def event
    parent.event
  end
  helper_method :event

  def angel
    parent.angel
  end
  helper_method :angel

  def registration
    @registration ||= Registration.find(params[:id])
  end
  helper_method :registration

  class EventParent
    attr_reader :event, :controller

    def initialize(event, controller)
      @event = event
      @controller = controller
    end

    def index_url
      controller.office_event_registrations_url(event)
    end

    def registrations
      event.registrations.by_first_name
    end

    def angels
      event.registrations.ok.by_first_name.map(&:angel)
    end

    def ar_object
      event
    end
  end

  class AngelParent
    attr_reader :angel, :controller

    def initialize(angel, controller)
      @angel = angel
      @controller = controller
    end

    def index_url
      controller.office_angel_url(angel)
    end

    def registrations
      angel.registrations.by_start_date
    end

    def angels
      [angel]
    end

    def ar_object
      angel
    end

    def event
      nil
    end
  end
end
