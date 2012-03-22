class Office::SiteDefaults::EmailNamesController < Office::ApplicationController
  before_filter :find_email_name, :except => [:index, :new, :create]

  def index
    @email_names = EmailName.all
  end

  def new
    @email_name = EmailName.new.add_missing_locales
  end

  def create
    @email_name = EmailName.new(params[:email_name])
    if email_name.save
      redirect_to(office_site_defaults_email_names_url, notice: 'Email has been successfully created')
    else
      # empty emails were deleted during save, add them back
      email_name.add_missing_locales
      render 'new'
    end
  end

  def show
  end

  def edit
    email_name.add_missing_locales
  end

  def update
    if email_name.update_attributes(params[:email_name])
      redirect_to(office_site_defaults_email_names_url, :notice => 'Email was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    email_name.destroy
    redirect_to(office_site_defaults_email_names_url, notice: 'Email has been removed.')
  end

private

  def email_name
    @email_name ||= EmailName.find_by_id(params['id'])
  end
  helper_method :email_name

  def find_email_name
    unless email_name
      redirect_to(office_site_defaults_email_names_url, :alert => 'You must select an email first.')
    end
  end

end