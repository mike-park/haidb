class PublicSignupsController < ApplicationController
  layout :layout

  def new
    @public_signup = PublicSignup.new(registration: registration)
  end

  def create
    @public_signup = PublicSignup.new(public_signup_params)
    if @public_signup.registration
      set_user_language(@public_signup.registration.lang)
      @public_signup.registration.find_or_initialize_angel
    end
    if @public_signup.save
      send_email
      redirect_to thankyou_url
    else
      # fixes bug where "0" (unchecked box value) gets rerendered as checked state
      unless @public_signup.terms_and_conditions == '1'
        @public_signup.terms_and_conditions = nil
      end
      render :new
    end
  end

  def thank_you
  end

  private

  def public_signup_params
    params.require(:public_signup).
        permit(:terms_and_conditions,
               registration_attributes: [:event_id, :role, :backjack_rental, :sunday_stayover, :sunday_meal,
                                         :sunday_choice, :lift, :payment_method, :iban, :bank_account_name,
                                         :bank_name, :bic, :notes, :how_hear, :previous_event, :first_name,
                                         :last_name, :gender, :address, :postal_code, :city, :country,
                                         :email, :home_phone, :mobile_phone, :work_phone, :lang, :highest_level,
                                         :highest_location, :highest_date, :special_diet])
  end

  def layout
    "#{Site.name}_site"
  end

  def send_email
    @public_signup.send_email(EventEmail::SIGNUP)
  end

  def thankyou_url
    SiteDefault.get('public_signup.form.success_url') || thank_you_public_signups_path(locale: lang)
  end

  def registration
    Registration.new(payment_method: payment_method, lang: lang, event: event)
  end

  def payment_method
    Site.de? ? Registration::PAY_DEBT : Registration::PAY_TRANSFER
  end

  def lang
    I18n.locale.to_s
  end

  def event
    params[:event_id] && Event.upcoming.where(id: params[:event_id]).first
  end
end
