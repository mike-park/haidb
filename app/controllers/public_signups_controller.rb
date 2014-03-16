class PublicSignupsController < ApplicationController
  before_filter :build_public_signup, only: [:new]

  def new
    render_site_with_template('new')
  end

  def create
    @public_signup = PublicSignup.new(params[:public_signup])
    if @public_signup.save
      assign_angel
      send_email
      redirect_to thankyou_url
    else
      # fixes bug where "0" (unchecked box value) gets rerendered as checked state
      unless @public_signup.terms_and_conditions == '1'
        @public_signup.terms_and_conditions = nil
      end
      render_site_with_template('new')
    end
  end

  def show
    render_site_with_template('thankyou')
  end

  private

  def send_email
    @public_signup.send_email(EventEmail::SIGNUP)
  end

  def assign_angel
    Angel.add_to(@public_signup.registration)
  end

  def build_public_signup
    @public_signup = PublicSignup.new(registration: registration)
  end

  def thankyou_url
    SiteDefault.get('public_signup.form.success_url') || public_signup_url(0, template_version: template_version)
  end

  def render_site_with_template(name)
    @basedir = "public_signups/#{Site.name}"
    render "#{@basedir}/#{name}", :layout => "#{Site.name}#{template_version}_site"
  end

  def template_version
    @version ||= params[:template_version].to_s.match(/\d+/).to_s
  end
  helper_method :template_version

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
