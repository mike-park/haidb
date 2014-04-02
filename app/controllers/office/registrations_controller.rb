class Office::RegistrationsController < Office::ApplicationController
  before_filter :event
  before_filter :registration, only: [:edit, :update, :show, :destroy]

  def index
    respond_to do |format|
      format.html
      format.csv { send_data Registration.to_csv(registrations.ok), filename: "#{event.display_name}.csv", type: :csv }
      format.vcard { send_data Registration.to_vcard(registrations.ok), filename: "#{event.display_name}.vcf", type: :vcard }
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

  def show
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
