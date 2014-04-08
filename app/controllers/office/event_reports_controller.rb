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

  def event
    @event ||= Event.find(params[:event_id])
  end
end