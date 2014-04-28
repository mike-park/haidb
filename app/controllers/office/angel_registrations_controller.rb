class Office::AngelRegistrationsController < Office::ApplicationController
  before_filter :angel

  def new
    @registration = build_registration_from_angel(angel)
  end

  def create
    @registration = new_registration(registration_params)
    @registration.angel = angel
    @registration.approve
    if @registration.save
      redirect_to [:office, angel], notice: 'Registration added'
    else
      render :new
    end
  end

  def destroy
    registration = angel.registrations.find(params[:id])
    registration.destroy
    redirect_to [:office, angel], notice: 'Registration destroyed'
  end

  private

  def registration_params
    params.require(:registration).permit!
  end

  def build_registration_from_angel(angel)
    registration = new_registration
    Registration::REGISTRATION_FIELDS.each do |field|
      registration.send("#{field}=", angel.send(field))
    end
    registration.angel = angel
    registration
  end

  def new_registration(attributes = {})
    Registration.new(attributes) do |registration|
      registration.approve
    end
  end

  def angel
    @angel ||= Angel.find(params[:angel_id])
  end
end

