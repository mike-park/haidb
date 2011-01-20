module Office::Registrations::CheckedInHelper

  def checked_in_registration_tds(registration)
    first = {:class => :false} unless registration.checked_in?
    second = {:class => :true} if registration.checked_in?

    html = content_tag(:td, '', first)
    html << content_tag(:td, '', second)
    html.html_safe
  end

  def checked_in_toggle(registration)
    form_tag({ :action => "update",
               :controller => "office/registrations/checked_in",
               :event_id => event,
               :id => registration },
             { :method => :put }) do
      submit_tag('Toggle')
    end
  end
end
