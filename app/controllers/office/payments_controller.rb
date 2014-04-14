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
    @payment = payments.build(params[:payment])
    if @payment.save
      redirect_to office_registration_payments_path(registration), notice: 'Payment was successfully created.'
    else
      render action: :new
    end
  end

  def update
    @payment = payments.find(params[:id])

    if @payment.update_attributes(params[:payment])
      redirect_to office_registration_payments_path(registration), notice: 'Payment was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @payment = payments.find(params[:id])
    @payment.destroy

    redirect_to office_registration_payments_path(registration)
  end

  protected

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
