class Office::EventReportsController < Office::ApplicationController
  before_filter :event

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

  def status
    respond_to do |format|
      format.html
      format.csv   { send_data Registration.to_csv(event.registrations), filename: csv_file_name, type: :csv }
      format.vcard { send_data Registration.to_vcard(event.registrations.approved), filename: vcf_file_name, type: :vcard }
    end
  end

  private

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

  def event
    @event ||= Event.find(params[:event_id])
  end
end