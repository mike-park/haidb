class Office::EventReportsController < Office::ApplicationController
  before_filter :event
  before_filter :title

  def site
    csv_fields = [:role, :status, :full_name, :email, :gender,
                  :special_diet, :lift, :backjack_rental, :sunday_stayover, :sunday_meal, :room, :notes]
    standard_response(csv_fields)
  end

  def bank
    csv_fields = [:role, :status, :full_name, :email,
                  :address, :postal_code, :city, :country,
                  :payment_method, :bank_account_name, :iban, :bic,
                  :registration_code, :cost, :paid, :owed, :completed, :notes]
    standard_response(csv_fields)
  end

  def client_history
    csv_fields = [:role, :status, :full_name, :email, :gender, :how_hear, :previous_event,
                  :highest_level, :highest_location, :highest_date]
    standard_response(csv_fields)
  end

  def payment
    csv_fields = [:role, :status, :full_name, :email, :cost, :paid, :owed, :notes]
    standard_response(csv_fields)
  end

  def status
    respond_to do |format|
      format.html
      format.csv { send_data Registration.to_csv(approved_registrations), filename: csv_file_name, type: :csv }
      format.vcard { send_data Registration.to_vcard(approved_registrations), filename: vcf_file_name, type: :vcard }
    end
  end

  def checklist
    csv_fields = [:role, :status, :full_name, :email, :gender,
                  :backjack_rental, :sunday_meal, :sunday_stayover, :payment_method]
    respond_to do |format|
      format.html
      format.csv { send_data Registration.to_csv(approved_registrations, csv_fields), filename: csv_file_name, type: :csv }
      format.pdf { send_data render_to_string(:layout => false), filename: pdf_file_name, type: :pdf }
    end
  end

  def roster
    csv_fields = [:role, :status, :full_name, :email,
                  :address, :postal_code, :city, :country,
                  :home_phone, :mobile_phone, :work_phone]
    @roster = RosterDecorator.new(Roster.new(event))
    respond_to do |format|
      format.html
      format.csv { send_data Registration.to_csv(completed_registrations, csv_fields), filename: csv_file_name, type: :csv }
      format.pdf { send_data(@roster.to_pdf, filename: @roster.filename, type: :pdf) }
    end
  end

  concerning :Maps do

    # copied from http://google-maps-icons.googlecode.com/files/XXX.png so we can use https
    PARKANDRIDE_PICTURE = {picture: '/images/parkandride.png', width: 32, height: 37}
    SITE_PICTURE = {picture: '/images/moderntower.png', width: 32, height: 37}
    CAR_PICTURE = {picture: '/images/car.png', width: 32, height: 37}

    TEAM_PICTURE = {picture: '/images/team.png', width: 19, height: 34}
    FACILITATOR_PICTURE = {picture: '/images/facilitator.png', width: 19, height: 34}
    PARTICIPANT_PICTURE = {picture: '/images/participant.png', width: 19, height: 34}

    ROLE_TO_PICTURE = {Registration::TEAM => TEAM_PICTURE,
                       Registration::FACILITATOR => FACILITATOR_PICTURE,
                       Registration::PARTICIPANT => PARTICIPANT_PICTURE
    }

    def map
      params[:q] ||= {}
      @q = event.registrations.search(params[:q])
      @json = @q.result.to_gmaps4rails do |reg, marker|
        marker.infowindow render_to_string(:partial => '/office/event_reports/map_info',
                                           :locals => {registrations: registrations_at(reg.lat, reg.lng)})
        marker.picture(registration_picture(reg))
        marker.title reg.full_name
      end
    end

    private

    def registration_picture(registration)
      case registration.lift
        when Registration::REQUESTED
          PARKANDRIDE_PICTURE
        when Registration::OFFERED
          CAR_PICTURE
        else
          ROLE_TO_PICTURE[registration.role]
      end
    end

    def registrations_at(lat, lng)
      event.registrations.located_at(lat, lng)
    end
  end

  def completed
    @registrations = approved_registrations
  end

  private

  def approved_registrations
    event.registrations.approved.by_first_name
  end

  def completed_registrations
    event.completed_registrations.by_first_name
  end

  def title
    @title ||= "#{event.display_name} #{action_name.humanize}"
  end

  def standard_response(csv_fields)
    respond_to do |format|
      format.html
      format.csv { send_data Registration.to_csv(event.registrations, csv_fields), filename: csv_file_name, type: :csv }
    end
  end

  def csv_file_name
    "#{event.display_name}_#{action_name}_report.csv"
  end

  def vcf_file_name
    "#{event.display_name}.vcf"
  end

  def pdf_file_name
    "#{event.display_name}_#{action_name}.pdf"
  end

  def event
    @event ||= Event.find(params[:event_id])
  end
end