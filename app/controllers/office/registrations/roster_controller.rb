class Office::Registrations::RosterController < Office::RegistrationsController
  def index
    # HACK ALERT! 
    if Site.de?
      I18n.locale = :de
    else
      I18n.locale = :en
    end
    @title = translate('enums.registration.roster.title', :event => event.display_name)
    # @password = translate('enums.registration.roster.password')
    respond_to do |format|
      format.html
      format.pdf do
        send_data render_to_string(:layout => false), {
          :filename => "#{event.display_name} roster.pdf",
          :type => :pdf
        }
      end
    end
  end
end
