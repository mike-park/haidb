module Office::Registrations::PostHelper

  def color_dot(state)
    content_tag(:div, '', :class => state ? :true : :false)
  end
  
end
