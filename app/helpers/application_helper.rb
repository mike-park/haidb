module ApplicationHelper
  def language?(lang)
    I18n.locale.to_s == lang.to_s
  end

  def sd(key)
    value = SiteDefault.get(key)
    value.html_safe if value
  end

  def map_address(addr, options = {})
    q = addr.gsub("\n", ",")
    options[:tag] ||= :a
    if (I18n.locale.to_s || '').downcase == 'de'
      options[:lang] ||= 'de'
      options[:url] ||= 'de'
    else
      options[:lang] ||= 'en'
      options[:url] ||= 'co.uk'
    end
    params = { :f => 'q', :hl => options[:lang], :z => 10, :q => q }.to_param
    url = "http://maps.google.#{options[:url]}/maps?#{params}"
    content_tag(options[:tag], addr, {:href => url}, false)
  end


  # return positive tick if field is considered true
  def checkmark_if(field, code = '&#10003;')
    code.html_safe if !!field
  end

  ICON_SIZE='16x16'

  # generate edit link with icon
  def link_to_edit(path)
    link_to icon('edit'), path, title: 'Edit this record'
  end

  # new link with icon
  def link_to_new(path, message = '')
    message = icon('plus-sign') + ' ' + message
    link_to message, path, title: 'Create a new record'
  end

  # destroy link with icon
  def link_to_destroy(path)
    link_to icon('remove-sign'), path, :confirm => 'Are you sure?', :method => :delete, title: 'Delete this record'
  end

  def link_to_registrations(path)
    link_to icon('user'), path, title: 'Show registrations'
  end

  # return object model name. ie Angel object => 'angel'
  def model_name(model)
    model.class.to_s.downcase
  end

  def local_currency(number)
    locale = Site.de? ? 'de' : 'en-GB'
    number_to_currency(number, locale: locale) if number
  end

  def local_date(date)
    localize(date) if date
  end

  private

  def new_label(label, order)
    [label.humanize, order_indicator_for(order)].compact.join(' ').html_safe
  end
  
  def order_indicator_for(order)
    if order == 'asc'
      '&#9650;'
    elsif order == 'desc'
      '&#9660;'
    else
      nil
    end
  end
  
end
