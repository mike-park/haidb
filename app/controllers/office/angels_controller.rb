class Office::AngelsController < Office::ApplicationController
  before_filter :find_angel, :except => [:index, :past, :new, :create]

  def index
    params[:rows] ||= 5
    params[:search] ||= {}
    params[:search][:meta_sort] ||= 'updated_at.desc'
    @search = Angel.search(params[:search])
    @angels = @search.paginate(:page => params[:page],
                               :per_page => params[:rows])
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

  def destroy
    angel.destroy
    redirect_to(office_angels_url, :notice => 'Angel was successfully deleted.')
  end

  protected

  def find_angel
    unless angel
      redirect_to(office_angels_url, :alert => 'You must select an angel first.')
    end
  end

  def angel
    @angel ||= Angel.find_by_id(params[:id])
  end
  helper_method :angel
  hide_action :angel

  def angels
    @angels
  end
  helper_method :angels
  hide_action :angels

end
