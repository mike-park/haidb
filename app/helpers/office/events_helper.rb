module Office::EventsHelper

  def options_for_event_categories(form)
    { :as => :radio, :collection => Event::CATEGORIES }
  end

end
