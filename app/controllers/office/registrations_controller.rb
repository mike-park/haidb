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
      redirect_to([:office, parent, :registrations],
                  :notice => 'Registration was successfully created.')
    else
      render :new
    end
  end

  def update
    if registration.update_attributes(params[:registration])
      redirect_to([:office, parent, :registrations],
                  :notice => 'Registration was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    registration.destroy
    redirect_to([:office, parent, :registrations],
                :notice => 'Registration was successfully deleted.')
  end
  

  protected

  def parent
    @parent ||= event || angel
  end
end
