class Office::PublicSignupsController < Office::ApplicationController
  before_filter :find_signup, :except => [:index, :waitlisted, :approved]
  
  def index
    @public_signups = PublicSignup.pending.by_created_at
  end

  def waitlisted
    @public_signups = PublicSignup.waitlisted.by_created_at
  end

  def approved
    params[:rows] ||= 10
    params[:search] ||= {}
    params[:search][:meta_sort] ||= 'approved_at.desc'
    @search = PublicSignup.approved.search(params[:search])
    @public_signups = @search.paginate :page => params[:page], :per_page => params[:rows]
  end

  def update
    if public_signup.update_attributes(params[:public_signup])
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
    public_signup.set_waitlisted!
    public_signup.send_email(EventEmail::PENDING)
    redirect_to(office_public_signups_url, :notice => "#{public_signup.full_name} has been waitlisted.")
  end

  def destroy
    public_signup.destroy
    redirect_to(office_public_signups_url, :notice => 'Public signup was deleted.')
  end
  
  protected

  def find_signup
    unless public_signup
      redirect_to(office_public_signups_url, :alert => 'You must select a signup first.')
    end
  end

  def public_signup
    @public_signup ||= PublicSignup.find_by_id(params[:id])
  end
  helper_method :public_signup

  def public_signups
    @public_signups
  end
  helper_method :public_signups
end
