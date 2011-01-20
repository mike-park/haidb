class Office::AngelsController < Office::ApplicationController
  before_filter :find_angel, :except => [:index, :level, :map, :new, :create]

  def index
    find_angels(5, 'updated_at.desc')
  end

  def level
    find_angels(10, 'first_name.asc')
  end

  def map
    params[:search] ||= {}
    @search = Angel.geocoded.search(params[:search])

    @map = Cartographer::Gmap.new( 'map', :debug => true )
    @map.zoom = :bound
    
    icon = Cartographer::Gicon.new
    @map.icons << icon

    @search.all.each do |angel|
      @map.markers << Cartographer::Gmarker.new(:name => "id#{angel.id}",
           :marker_type => "Person",
           :position => [angel.lat,angel.lng],
           :info_window_url => office_angel_url(angel, :format => :map),
           :icon => icon)
    end

    respond_to do |format|
      format.html
      format.vcard do
        send_data Angel.to_vcard(@search.all), {
          :filename => 'contacts.vcf',
          :type => :vcard
        }
      end
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
      format.map { render :layout => false }
      format.html
      format.vcard { send_data angel.to_vcard, :filename => 'contact.vcf', :type => :vcard }
    end
  end

  def destroy
    angel.destroy
    redirect_to(office_angels_url, :notice => 'Angel was successfully deleted.')
  end

  protected

  def find_angels(rows, sort)
    params[:rows] ||= rows
    params[:search] ||= {}
    params[:search][:meta_sort] ||= sort
    @search = Angel.search(params[:search])
    @angels = @search.paginate(:page => params[:page],
                               :per_page => params[:rows])

    respond_to do |format|
      format.html
      format.vcard do
        send_data Angel.to_vcard(@search.all), {
          :filename => 'contacts.vcf',
          :type => :vcard
        }
      end
    end
  end

  def parent
    @parent ||= angel
  end
  
  def registrations
    @registrations ||= parent.registrations.ok.by_start_date
  end
  
end
