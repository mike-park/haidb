class Office::PaymentsController < Office::ApplicationController
  before_filter :event

  def index
    @payments = payments.by_date
  end

  def show
    @payment = payments.find(params[:id])
  end

  def new
    @payment = payments.build
  end

  def edit
    @payment = payments.find(params[:id])
  end

  def create
    @payment = payments.build(payment_params)
    if @payment.save
      redirect_to office_registration_payments_path(registration), notice: 'Payment was successfully created.'
    else
      render action: :new
    end
  end

  def update
    @payment = payments.find(params[:id])

    if @payment.update(payment_params)
      redirect_to office_registration_payments_path(registration), notice: 'Payment was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    payment = payments.find(params[:id])
    payment.destroy

    redirect_to office_registration_payments_path(registration)
  end

  protected

  def payment_params
    params.require(:payment).permit(:paid_on, :note, :amount)
  end

  def event
    @event ||= registration.event
  end

  def registration
    @registration ||= Registration.find(params[:registration_id])
  end

  def payments
    registration.payments
  end
end
