class Office::SiteDefaults::EmailNamesController < Office::ApplicationController
  def index
    @email_names = EmailName.by_name
  end

  def new
    @email_name = EmailName.new.add_missing_locales
  end

  def create
    @email_name = EmailName.new(email_name_params)
    if @email_name.save
      redirect_to(office_site_defaults_email_name_path(@email_name), notice: 'Email has been successfully created')
    else
      # empty emails were deleted during save, add them back
      @email_name.add_missing_locales
      render 'new'
    end
  end

  def show
    @email_name = EmailName.find(params[:id])
  end

  def edit
    @email_name = EmailName.find(params[:id])
    @email_name.add_missing_locales
  end

  def update
    @email_name = EmailName.find(params[:id])
    if @email_name.update(email_name_params)
      redirect_to(office_site_defaults_email_name_path(@email_name), :notice => 'Email was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    email_name = EmailName.find(params[:id])
    email_name.destroy
    redirect_to(office_site_defaults_email_names_url, notice: 'Email has been removed.')
  end

private

  def email_name_params
    params.require(:email_name).permit(:name, emails_attributes: [:_destroy, :id, :email_name_id, :locale, :subject, :body])
  end
end