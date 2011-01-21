class Office::RegistrationsController < Office::ApplicationController
  before_filter :find_event_or_angel
  
  def index
    respond_to do |format|
      format.html
      format.vcard do
        send_data Angel.to_vcard(registrations.all.map(&:angel)), {
          :filename => 'contacts.vcf',
          :type => :vcard
        }
      end
    end
  end
  
  def new
    @registration = registrations.new(params[:registration])
  end
    
  def create
    @registration = registrations.new(params[:registration])
    @registration.approved = true
    if @registration.save
      redirect_to(back_url,
                  :notice => 'Registration was successfully created.')
    else
      render :new
    end
  end

  def update
    if registration.update_attributes(params[:registration])
      redirect_to(back_url,
                  :notice => 'Registration was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    registration.destroy
    redirect_to(back_url,
                :notice => 'Registration was successfully deleted.')
  end
  

  protected

  def back_url
    if have_event?
      office_event_pre_index_url(parent)
    else
      office_angel_url(parent)
    end
  end
  
  def find_event_or_angel
    unless parent
      redirect_to(office_events_url, :alert => 'You must select an event first')
    end
  end

  def parent
    @parent ||= event || angel
  end
  helper_method :parent
  hide_action :parent

  def have_event?
    parent.is_a?(Event)
  end
  helper_method :have_event?
  hide_action :have_event?

  def registrations
    if have_event?
      @registrations ||= parent.registrations.ok.by_first_name
    else
      @registrations ||= parent.registrations.ok.by_start_date
    end
  end
  helper_method :registrations
  hide_action :registrations
end
