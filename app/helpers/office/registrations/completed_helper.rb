module Office::Registrations::CompletedHelper

  def completed_registration_tds(registration)
    first = {:class => :false} unless registration.completed?
    second = {:class => :true} if registration.completed?

    html = content_tag(:td, '', first)
    html << content_tag(:td, '', second)
    html.html_safe
  end

  def completed_toggle(registration)
    form_tag({ :action => "update",
               :controller => "office/registrations/completed",
               :event_id => event,
               :id => registration },
             { :method => :put }) do
      submit_tag('Toggle')
    end
  end
end
