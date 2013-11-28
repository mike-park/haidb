class PublicSignupsController < ApplicationController
  def new
    @public_signup = PublicSignup.new(registration_attributes: { event_id: params[:event_id], angel_attributes: {}})
    render_site_with_template('new')
  end

  def create
    @public_signup = PublicSignup.new(params_with_nested_models)
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

  def thankyou_url
    SiteDefault.get('public_signup.form.success_url') || public_signup_url(0, template_version: template_version)
  end

  # ensure we have a nested registration_attributes and within that angel_attributes
  def params_with_nested_models
    {registration_attributes: {angel_attributes: {}}}.with_indifferent_access.merge(params[:public_signup] || {})
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
