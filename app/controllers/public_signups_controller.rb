class PublicSignupsController < ApplicationController
  def new
    @public_signup = PublicSignup.new(registration_attributes: { angel_attributes: {}})
    render_site_new_template
  end

  def create
    @public_signup = PublicSignup.new(params_with_nested_models)
    if @public_signup.save
      redirect_to Site.thankyou_url
      @public_signup.send_email(EventEmail::SIGNUP)
    else
      # fixes bug where "0" (unchecked box value) gets rerendered as checked state
      unless @public_signup.terms_and_conditions == '1'
        @public_signup.terms_and_conditions = nil
      end
      render_site_new_template
    end
  end

  protected

  # ensure we have a nested registration_attributes and within that angel_attributes
  def params_with_nested_models
    {registration_attributes: {angel_attributes: {}}}.with_indifferent_access.merge(params[:public_signup] || {})
  end

  def render_site_new_template
    @basedir = "public_signups/#{Site.name}"
    render "#{@basedir}/new", :layout => "#{Site.name}_site"
  end
end
