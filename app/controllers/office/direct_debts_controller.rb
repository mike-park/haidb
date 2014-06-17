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
      respond_to do |format|
        format.html
        format.csv { send_data @direct_debt.to_csv, filename: csv_file_name, type: :csv }
      end
    else
      render :new
    end
  end

  private

  def direct_debt_params
    params.require(:direct_debt).permit(:post_date, :to_iban, :comment, checked: [])
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