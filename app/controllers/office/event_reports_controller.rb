class Office::EventReportsController < Office::ApplicationController
  before_filter :event
  before_filter :title

  def site
    csv_fields = [:role, :status, :full_name, :email, :gender, :special_diet, :lift, :backjack_rental, :sunday_stayover, :sunday_meal]
    standard_response(csv_fields)
  end

  def bank
    csv_fields = [:role, :status, :full_name, :email,
                  :address, :postal_code, :city, :country,
                  :payment_method, :bank_account_name, :iban, :bic,
                  :registration_code, :cost, :paid, :owed, :completed]
    standard_response(csv_fields)
  end

  def client_history
      csv_fields = [:role, :status, :full_name, :email, :gender, :how_hear, :previous_event,
                    :highest_level, :highest_location, :highest_date]
    standard_response(csv_fields)
  end

  def payment
    csv_fields = [:role, :status, :full_name, :email, :cost, :paid, :owed]
    standard_response(csv_fields)
  end

  def status
    respond_to do |format|
      format.html
      format.csv   { send_data Registration.to_csv(event.registrations), filename: csv_file_name, type: :csv }
      format.vcard { send_data Registration.to_vcard(event.registrations.approved), filename: vcf_file_name, type: :vcard }
    end
  end

  def checklist
    csv_fields = [:role, :status, :full_name, :email, :gender,
                  :backjack_rental, :sunday_meal, :sunday_stayover, :payment_method]
    respond_to do |format|
      format.html
      format.csv { send_data Registration.to_csv(event.registrations.approved, csv_fields), filename: csv_file_name, type: :csv }
      format.pdf { send_data render_to_string(:layout => false), filename: pdf_file_name, type: :pdf }
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

  def title
    @title ||= "#{event.display_name} #{action_name.humanize}"
  end

  def standard_response(csv_fields)
    respond_to do |format|
      format.html
      format.csv   { send_data Registration.to_csv(event.registrations, csv_fields), filename: csv_file_name, type: :csv }
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