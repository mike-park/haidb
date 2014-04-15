class Office::SiteDefaultsController < Office::ApplicationController
  before_filter :find_site_default, :except => [:index, :new, :create]
  
  def index
    params[:q] ||= {}
    params[:q][:meta_sort] ||= 'translation_key_key asc'
    params[:rows] ||= 10
    @q = SiteDefault.search(params[:q])
    @site_defaults = @q.result.paginate(:page => params[:page],
                                      :per_page => params[:rows])
  end

  def new
    @site_default = SiteDefault.new
  end

  def create
    @site_default = SiteDefault.new(params[:site_default])

    if @site_default.save
      redirect_to([:office, @site_default], :notice => 'New default was successfully created.')
    else
      render :new
    end
  end

  def update
    if site_default.update_attributes(params[:site_default])
      redirect_to([:office, site_default], :notice => 'Default was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    site_default.destroy
    redirect_to(office_site_defaults_url, :notice => 'Default was successfully deleted.')
  end

  protected

  def find_site_default
    unless site_default
      redirect_to(office_site_defaults_url, :alert => 'You must select a default first.')
    end
  end

  def site_default
    @site_default ||= SiteDefault.find_by_id(params[:site_default_id] || params[:id])
  end
  helper_method :site_default
  hide_action :site_default

  def site_defaults
    @site_defaults
  end
  helper_method :site_defaults
  hide_action :site_defaults
  
end
