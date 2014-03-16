class Office::AngelsController < Office::ApplicationController
  before_filter :find_angel, :except => [:index, :map, :map_info, :new, :create]

  def index
    find_angels(10, 'updated_at.desc')
  end

  def map
    params[:search] ||= params[:id] ? {id_eq: params[:id]} : {}
    @search = Angel.search(params[:search])
    @json = @search.all.to_gmaps4rails do |angel, marker|
      marker.infowindow render_to_string(:partial => '/office/angels/map_info',
                                         :locals => { angels: Angel.located_at(angel.lat, angel.lng) })
      marker.title angel.full_name
    end
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
      format.vcard { send_data angel.to_vcard, filename: "#{angel.full_name}.vcf", type: :vcard }
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
      format.csv   { send_data Angel.to_csv(@search.all), filename: 'contacts.csv', type: :csv }
      format.vcard { send_data Angel.to_vcard(@search.all), filename: 'contacts.vcf', type: :vcard }
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

  def angel
    @angel ||= Angel.find_by_id(params[:id])
  end
  helper_method :angel
end
