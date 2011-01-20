module Office::Registrations::CompletedHelper

  def completed_registration_tds(registration)
    first = {:class => :false} unless registration.completed?
    second = {:class => :true} if registration.completed?

    html = content_tag(:td, '', first)
    html << content_tag(:td, '', second)
    html.html_safe
  end
  
end
