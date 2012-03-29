class Office::RegistrationsController < Office::ApplicationController
  before_filter :find_event_or_angel
  before_filter :verify_registration_exists, only: [:edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.csv do
        send_data Angel.to_csv(registrations.ok.all.map(&:angel)), {
            :filename => "#{parent.display_name} contacts.csv",
            :type => :csv
        }
      end
      format.vcard do
        send_data Angel.to_vcard(registrations.ok.all.map(&:angel)), {
            :filename => "#{parent.display_name} contacts.vcf",
            :type => :vcard
        }
      end
    end
  end

  def new
    @registration = registrations.new(params[:registration])
  end

  def create
    @registration = registrations.new(params[:registration])
    @registration.approved = true
    if @registration.save
      redirect_to(back_url,
                  :notice => 'Registration was successfully created.')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if registration.update_attributes(params[:registration])
      redirect_to(back_url,
                  :notice => 'Registration was successfully updated.')
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
    if have_event?
      office_event_registrations_url(parent)
    else
      office_angel_url(parent)
    end
  end

  def find_event_or_angel
    unless parent
      redirect_to(office_events_url, :alert => 'You must select an event first')
    end
  end

  def parent
    @parent ||= event || angel
  end
  helper_method :parent

  def have_event?
    parent.is_a?(Event)
  end
  helper_method :have_event?

  def registrations
    if have_event?
      @registrations ||= parent.registrations.ok.by_first_name
    else
      @registrations ||= parent.registrations.ok.by_start_date
    end
  end
  helper_method :registrations

  def angels
    if have_event?
      @angels ||= parent.registrations.ok.by_first_name.map(&:angel)
    else
      @angels ||= [parent]
    end
  end
  helper_method :angels
end
