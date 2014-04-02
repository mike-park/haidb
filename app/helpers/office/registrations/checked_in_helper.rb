module Office::Registrations::CheckedInHelper
  def checked_in_toggle(registration)
    form_tag({ :action => "update",
               :controller => "office/registrations/checked_in",
               :event_id => registration.event_id,
               :id => registration },
             { :method => :put }) do
      submit_tag('Toggle', class: 'btn')
    end
  end
end
