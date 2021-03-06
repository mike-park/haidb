class Office::PublicSignupsController < Office::ApplicationController
  before_filter :find_signup, :except => [:index, :waitlisted, :approved]
  
  def index
    @public_signups = PublicSignup.pending.group_by_event
  end

  def waitlisted
    @public_signups = PublicSignup.waitlisted.group_by_event
  end

  def approved
    @public_signups = PublicSignup.approved.order('approved_at desc').paginate :page => params[:page], :per_page => params[:rows]
  end

  def update
    if public_signup.update(public_signup_params)
      redirect_to([:office, public_signup], :notice => 'Public signup was successfully updated.')
    else
      render :edit
    end
  end

  def approve
    public_signup.approve!
    public_signup.send_email(EventEmail::APPROVED)
    redirect_to(office_public_signups_url, :notice => "#{public_signup.full_name} has been successfully added to #{public_signup.event_name}.")
  end

  def waitlist
    public_signup.waitlist!
    public_signup.send_email(EventEmail::PENDING)
    redirect_to(office_public_signups_url, :notice => "#{public_signup.full_name} has been waitlisted.")
  end

  def destroy
    public_signup.destroy
    redirect_to(office_public_signups_url, :notice => 'Public signup was deleted.')
  end
  
  protected

  def public_signup_params
    params.require(:public_signup).permit!
  end

  def find_signup
    unless public_signup
      redirect_to(office_public_signups_url, :alert => 'You must select a signup first.')
    end
  end

  def public_signup
    @public_signup ||= PublicSignup.where(id: params[:id]).first
  end
  helper_method :public_signup
end
