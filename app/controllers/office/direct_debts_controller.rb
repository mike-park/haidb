class Office::DirectDebtsController < Office::ApplicationController
  before_filter :event
  before_filter :title

  def new
    @direct_debt = DirectDebt.new_from(event)
  end

  def create
    @direct_debt = DirectDebt.new(direct_debt_params)
    @direct_debt.event = event
    if @direct_debt.valid?
      send_emails if @direct_debt.send_emails?
      respond_to do |format|
        format.html
        format.csv { send_data @direct_debt.to_csv, filename: csv_file_name, type: :csv }
      end
    else
      render :new
    end
  end

  private

  def send_emails
    @direct_debt.checked_registrations.each do |reg|
      reg.send_email(EventEmail::UPCOMING_DIRECT_DEBIT, from: current_staff.email,
                     post_date: @direct_debt.post_date, debt_send_date: @direct_debt.debt_send_date)
    end
    flash[:notice] = "#{@direct_debt.checked_registrations.length} emails sent"
  end

  def direct_debt_params
    params.require(:direct_debt).permit(:post_date, :debt_send_date, :to_iban, :comment, :send_emails, checked: [])
  end

  def event
    @event ||= Event.find(params[:event_id])
  end

  def title
    @title ||= "#{event.display_name} Direct Debt"
  end

  def csv_file_name
    "#{event.display_name}_direct_debt_report.csv"
  end
end
