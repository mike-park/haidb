class Office::Registrations::ChecklistController < Office::RegistrationsController
  def index
    @title = "#{event.display_name} Checklist"
    respond_to do |format|
      format.html
      format.pdf do
        send_data render_to_string(:layout => false), {
          :filename => "#{event.display_name} checklist.pdf",
          :type => :pdf,
        }
      end
    end
  end
end
