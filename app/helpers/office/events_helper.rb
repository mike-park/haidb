module Office::EventsHelper

  def options_for_event_categories(form)
    { :as => :radio, :collection => Event::CATEGORIES }
  end

  def input_for_event_email(form, category)
    form.semantic_fields_for :event_emails, form.object.event_emails.find_or_initialize_by_category(category) do |ef|
      string = ef.input(:category, :as => :hidden)
      string += ef.input(:email_name, :label => "#{category} Email Name")
      string
    end
  end
end
