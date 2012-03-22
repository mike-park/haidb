class Office::AngelsController < Office::ApplicationController
  before_filter :find_angel, :except => [:index, :map, :map_info, :new, :create]

  def index
    find_angels(10, 'updated_at.desc')
  end

  def map
    params[:search] ||= params[:id] ? {id_eq: params[:id]} : {}
    @search = Angel.geocoded.search(params[:search])

    @map = Cartographer::Gmap.new( 'map', :debug => true )
    @map.zoom = :bound
    
    icon = Cartographer::Gicon.new
    @map.icons << icon

    @search.all.each do |angel|
      @map.markers << angel.to_map_marker(icon, map_info_window_url(angel))
    end
  end

  # return info window contents for pointer on map located at lat, lng
  def map_info
    @angels = Angel.where(:lat => params[:lat], :lng => params[:lng])
    render :layout => false
  end

  def new
    @angel = Angel.new
  end

  def create
    @angel = Angel.new(params[:angel])
    if @angel.save
      redirect_to([:office, @angel], :notice => 'Angel was successfully created.')
    else
      render :new
    end
  end

  def update
    if angel.update_attributes(params[:angel])
      redirect_to([:office, angel], :notice => 'Angel was successfully updated.')
    else
      render :edit
    end
  end

  def show
    respond_to do |format|
      format.html
      format.vcard { send_data angel.to_vcard, :filename => "#{angel.full_name}.vcf", :type => :vcard }
    end
  end

  def destroy
    angel.destroy
    redirect_to(office_angels_url, :notice => 'Angel was successfully deleted.')
  end

  protected

  def map_info_window_url(angel)
    map_info_office_angels_url(:lat => angel.lat, :lng => angel.lng)
  end

  def find_angels(rows, sort)
    params[:rows] ||= rows
    params[:search] ||= {}
    params[:search][:meta_sort] ||= sort
    @search = Angel.search(params[:search])
    @angels = @search.paginate(:page => params[:page],
                               :per_page => params[:rows])

    respond_to do |format|
      format.html
      format.csv do
        send_data Angel.to_csv(@search.all), {
          :filename => 'contacts.csv',
          :type => :csv
        }
      end
      format.vcard do
        send_data Angel.to_vcard(@search.all), {
          :filename => 'contacts.vcf',
          :type => :vcard
        }
      end
    end
  end

  def find_angel
    unless angel
      redirect_to(office_angels_url, :alert => 'You must select an angel first.')
    end
  end

  def angels
    @angels
  end
  helper_method :angels

  def registrations
    @registrations ||= angel.registrations.ok.by_start_date
  end
  helper_method :registrations
end
