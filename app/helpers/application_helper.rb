module ApplicationHelper
  def language?(lang)
    I18n.locale.to_s == lang.to_s
  end

  ROW_COUNT_SELECTION = [5, 10, 30, 200]

  def options_for_row_count
    list = ROW_COUNT_SELECTION.map {|r| ["#{r} per page", r]}
    rows = params[:rows] || 10
    options_for_select(list, rows)
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
    link_to icon('icon-edit'), path, title: 'Edit this record'
  end

  # show link with icon
  def link_to_show(path, message = "".html_safe)
    link_to icon('icon-zoom-in') + message, path, title: 'Show more information'
  end

  # new link with icon
  def link_to_new(path, message = "".html_safe)
    link_to icon('icon-plus-sign') + message, path, title: 'Create a new record'
  end

  # destroy link with icon
  def link_to_destroy(path)
    link_to icon('icon-remove-sign'), path, :confirm => 'Are you sure?', :method => :delete, title: 'Delete this record'
  end

  def link_to_registrations(path)
    link_to icon('icon-user'), path, title: 'Show registrations'
  end

  # return object model name. ie Angel object => 'angel'
  def model_name(model)
    model.class.to_s.downcase
  end

  def link_to_logout(path, message = "Logout")
    content_tag(:ul, class: 'nav nav-pills pull-right') do
      content_tag(:li, link_to(message, path, method: :delete))
    end
  end

  def gravatar_image(data)
    return unless data.present?
    tag(:img, src: data)
  end

  def local_currency(number)
    locale = Site.de? ? 'de' : 'en-GB'
    number_to_currency(number, locale: locale)
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
