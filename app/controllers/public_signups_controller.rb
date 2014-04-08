class PublicSignupsController < ApplicationController
  layout :layout

  before_filter :build_public_signup, only: [:new]

  def new
  end

  def create
    @public_signup = PublicSignup.new(params[:public_signup])
    @public_signup.registration.find_or_initialize_angel if @public_signup.registration
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

  def show
  end

  private

  def layout
    "#{Site.name}_site"
  end

  def send_email
    @public_signup.send_email(EventEmail::SIGNUP)
  end

  def build_public_signup
    @public_signup = PublicSignup.new(registration: registration)
  end

  def thankyou_url
    SiteDefault.get('public_signup.form.success_url') || public_signup_url(0)
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
    params[:event_id] && Event.upcoming.find_by_id(params[:event_id])
  end
end
