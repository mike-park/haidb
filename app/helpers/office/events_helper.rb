module Office::EventsHelper

  def options_for_event_categories(form)
    { :as => :radio_buttons, :collection => Event::CATEGORIES }
  end

  def input_for_event_email(form, category)
    form.simple_fields_for(:event_emails,
                           form.object.event_emails.with_category(category).first_or_initialize,
                           form.options.slice(:wrapper_mappings)) do |ef|
      string = ef.input(:category, :as => :hidden)
      string += ef.association(:email_name, :label => "#{category} Email Name")
      string
    end
  end
end
