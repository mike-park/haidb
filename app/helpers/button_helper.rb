module ButtonHelper
  def new_button(options = {})
    options[:icon] ||= 'glyphicon glyphicon-plus-sign'
    button_with_options(:new, options)
  end

  def edit_button(options = {})
    button_with_options(:edit, options)
  end

  def delete_button(options = {})
    options[:icon] ||= 'glyphicon glyphicon-remove-sign'
    options[:label] ||= 'Delete'
    options[:html] ||= {}
    options[:html][:method] = :delete
    options[:html][:confirm] ||= I18n.translate('buttons.label.are_you_sure', default: 'Are you sure you want to delete this?')
    button_with_options(:destroy, options)
  end

  def refresh_button(options = {})
    options[:icon] ||= 'glyphicon glyphicon-refresh'
    options[:label] ||= 'Refresh'
    options[:html] ||= {}
    options[:html][:method] = :post
    button_with_options(:refresh, options)
  end

  def show_button(options = {})
    options[:label] ||= 'Show'
    options[:icon] ||= 'glyphicon glyphicon-zoom-in'
    button_with_options(:show, options)
  end

  def registrations_button(event)
    options = {}
    options[:icon] = 'glyphicon glyphicon-user'
    options[:label] = 'Registrations'
    options[:path] = status_office_event_report_path(event)
    button_with_options(:registrations, options)
  end

  def csv_button(options = {})
    options[:label] ||= 'Spreadsheet'
    options[:icon] ||= 'glyphicon glyphicon-th-list'
    options[:path] ||= url_for(params.merge(format: :csv))
    button_with_options(:csv, options)
  end

  def pdf_button(options = {})
    options[:label] ||= 'PDF'
    options[:icon] ||= 'glyphicon glyphicon-print'
    options[:path] ||= url_for(params.merge(format: :pdf))
    button_with_options(:pdf, options)
  end

  def vcard_button(options = {})
    options[:label] ||= 'Address Book'
    options[:icon] ||= 'glyphicon glyphicon-envelope'
    options[:path] ||= url_for(params.merge(format: :vcard))
    button_with_options(:vcard, options)
  end

  def map_button(options = {})
    options[:label] ||= 'Map'
    options[:icon] ||= 'glyphicon glyphicon-map-marker'
    options[:path] ||= url_for(params.merge(action: :map))
    button_with_options(:map, options)
  end

  def list_button(options = {})
    options[:label] ||= 'List'
    options[:icon] ||= 'glyphicon glyphicon-th-list'
    options[:path] ||= url_for(params.merge(action: :index))
    button_with_options(:map, options)
  end

  def button_with_options(action, options = {}, &block)
    options[:html] ||= {}
    options[:html][:class] = 'btn btn-info'
    options[:path] ||= url_for(action: action)
    options[:label] = I18n.translate("buttons.labels.#{action}", default: (options[:label] || action.to_s.humanize))
    options[:icon] ||= "glyphicon glyphicon-#{action}"

    yield(options) if block_given?

    link_to(options[:path], options[:html]) do
      content_tag(:i, nil, class: options[:icon]) + " #{options[:label]}"
    end
  end
end