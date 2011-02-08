class PublicSignupsController < ApplicationController
  def new
    @public_signup = PublicSignup.new
    render_site_new_template
  end

  def create
    @public_signup = PublicSignup.new(params[:public_signup])
    if @public_signup.save
      redirect_to Site.thankyou_url
      Notifier.public_signup_received(@public_signup).deliver
    else
      # fixes bug where "0" (unchecked box value) gets rerendered as checked state
      unless @public_signup.terms_and_conditions == '1'
        @public_signup.terms_and_conditions = nil
      end
      render_site_new_template
    end
  end

  protected
  def render_site_new_template
    @basedir = "public_signups/#{Site.name}"
    render "#{@basedir}/new", :layout => "#{Site.name}_site"
  end
end
