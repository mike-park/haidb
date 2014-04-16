class Office::SiteDefaultsController < Office::ApplicationController
  def index
    @site_defaults = SiteDefault.by_key
  end

  def new
    @site_default = SiteDefault.new
  end

  def create
    @site_default = SiteDefault.new(site_default_params)

    if @site_default.save
      redirect_to([:office, @site_default], :notice => 'New default was successfully created.')
    else
      render :new
    end
  end

  def edit
    @site_default = SiteDefault.find(params[:id])
  end

  def update
    @site_default = SiteDefault.find(params[:id])
    if @site_default.update(site_default_params)
      redirect_to([:office, @site_default], :notice => 'Default was successfully updated.')
    else
      render :edit
    end
  end

  def show
    @site_default = SiteDefault.find(params[:id])
  end

  def destroy
    site_default = SiteDefault.find(params[:id])
    site_default.destroy
    redirect_to(office_site_defaults_url, :notice => 'Default was successfully deleted.')
  end

  private

  def site_default_params
    params.require(:site_default).
        permit(:description,
               translation_key_attributes: [:id, :key,
                                            translations_attributes: [:id, :translation_key_id, :text, :locale]])
  end
end
