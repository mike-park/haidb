class Office::AngelsController < Office::ApplicationController
  def index
    params[:rows] ||= 30
    if params[:q]
      order = 'display_name asc'
    else
      params[:q] = {}
      order = 'updated_at desc'
    end
    @q = Angel.order(order).search(params[:q])
    @angels = @q.result.paginate(:page => params[:page],
                                 :per_page => params[:rows])

    respond_to do |format|
      format.html
      format.csv { send_data Angel.to_csv(@q.result), filename: 'contacts.csv', type: :csv }
      format.vcard { send_data Angel.to_vcard(@q.result), filename: 'contacts.vcf', type: :vcard }
    end
  end

  def map
    params[:q] ||= params[:id] ? {id_eq: params[:id]} : {}
    @q = Angel.search(params[:q])
    @json = @q.result.to_gmaps4rails do |angel, marker|
      marker.infowindow render_to_string(:partial => '/office/angels/map_info',
                                         :locals => {angels: Angel.located_at(angel.lat, angel.lng)})
      marker.title angel.full_name
    end
  end

  def new
    @angel = Angel.new
  end

  def create
    @angel = Angel.new(angel_params)
    if @angel.save
      redirect_to([:office, @angel], :notice => 'Angel was successfully created.')
    else
      render :new
    end
  end

  def edit
    @angel = Angel.find(params[:id])
  end

  def update
    @angel = Angel.find(params[:id])
    if @angel.update(angel_params)
      redirect_to([:office, @angel], :notice => 'Angel was successfully updated.')
    else
      render :edit
    end
  end

  def show
    @angel = Angel.find(params[:id])
    respond_to do |format|
      format.html
      format.vcard { send_data @angel.to_vcard, filename: "#{@angel.full_name}.vcf", type: :vcard }
    end
  end

  def destroy
    angel = Angel.find(params[:id])
    angel.destroy
    redirect_to(office_angels_url, :notice => 'Angel was successfully deleted.')
  end

  private

  def angel_params
    params.require(:angel).permit(:payment_method, :iban, :bank_account_name,
                                  :bic, :notes, :first_name,
                                  :last_name, :gender, :address, :postal_code, :city, :country,
                                  :email, :home_phone, :mobile_phone, :work_phone, :lang, :highest_level)
  end
end
