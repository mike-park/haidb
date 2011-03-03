module Office::ApplicationHelper

  def super_user?
    current_staff && current_staff.super_user?
  end

  def add_button_to(nav, action, *object)
    options = object.extract_options!
    object = object.first
    options.merge!(:id => object) unless object.nil?
    
    case action.to_s.downcase
    when /^(new|add)\b/
      path = url_for(options.merge(:action => :new))
      icon = {:icon => :add}
    when /^edit\b/
      path = url_for(options.merge(:action => :edit))
      icon = {:icon => :pencil}
    when /^delete\b/
      path = url_for(options.merge(:action => :destroy))
      icon = {:icon => :delete, :method => :delete}
    when /^show\b/
      path = url_for(options)
      icon = {:icon => :magnifier}
    when /^pdf\b/
      path = url_for(options)
      icon = {:icon => :page_white_acrobat}
    else
      display = action.to_s
      icon = options.extract!(:icon)
      path = url_for(options)
    end
    display = action.kind_of?(Symbol) ? action.to_s.capitalize : action.to_s
    nav.item(display, path, icon)
  end

end

