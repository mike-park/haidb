class PublicSignupsController < ApplicationController
  def new
    @public_signup = new_public_signup
    render_site_with_template('new')
  end

  def create
    @public_signup = PublicSignup.new(params[:public_signup])
    @public_signup.registration.assign_default_cost if @public_signup.registration
    if @public_signup.save
      redirect_to thankyou_url
      @public_signup.send_email(EventEmail::SIGNUP)
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

  protected

  def new_public_signup
    ps = PublicSignup.new
    registration = Registration.new(angel: Angel.new)
    registration.payment_method = Site.de? ? Registration::PAY_DEBT : Registration::PAY_TRANSFER
    ps.registration = registration
    if params[:event_id] && (event = Event.upcoming.find_by_id(params[:event_id]))
      ps.registration.event = event
    end
    ps
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
end
