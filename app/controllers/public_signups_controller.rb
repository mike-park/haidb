class PublicSignupsController < ApplicationController
  def new
    @public_signup = PublicSignup.new
    @public_signup.build_registration
    @public_signup.registration.build_angel
  end

  def create
    @public_signup = PublicSignup.new(params[:public_signup])
    @public_signup.registration.role = Registration::PARTICIPANT
    @public_signup.registration.approved = false
    @public_signup.registration.angel.lang = I18n.locale
    unless german?
      @public_signup.registration.payment_method = Registration::POST
    end

    # testing code
    #@public_signup.valid?
    #render :new
    #return

    if @public_signup.save
      redirect_to thankyou_url
    else
      # fixes bug where "0" (unchecked box value) gets rerendered as checked state
      unless @public_signup.terms_and_conditions == '1'
        @public_signup.terms_and_conditions = nil
      end
      render :new
    end
  end

  protected
  def german?
    I18n.locale.to_s == 'de'
  end
  helper_method :german?
end
