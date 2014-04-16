module Office::ApplicationHelper

  def vertical_form(path_or_resource, options = {}, &block)
    wrapper = {
        wrapper: :vertical_form,
        wrapper_mappings: {
            check_boxes: :vertical_radio_and_checkboxes,
            radio_buttons: :vertical_radio_and_checkboxes,
            file: :vertical_file_input,
            boolean: :vertical_boolean
        }}
    options = options.merge(wrapper)
    simple_form_for(path_or_resource, options, &block)
  end

  def horizontal_form(path_or_resource, options = {}, &block)
    wrapper = {
        wrapper: :horizontal_form,
        wrapper_mappings: {
            check_boxes: :horizontal_radio_and_checkboxes,
            radio_buttons: :horizontal_radio_and_checkboxes,
            file: :horizontal_file_input,
            boolean: :horizontal_boolean
        }}
    options = options.merge(wrapper)
    options[:html] ||= {}
    options[:html][:class] = "form-horizontal #{options[:html][:class]}"
    simple_form_for(path_or_resource, options, &block)
  end

  def super_user?
    current_staff && current_staff.super_user?
  end

  def add_email_button_to(nav, options)
    count = 0
    [:cc, :bcc].each do |name|
      if (list = options[name])
        count += list.length
        options[name] = list.join(',')
      end
    end
    label = icon('envelope') + "Email #{count}"
    options[:class] = 'btn'
    nav << mail_to(current_staff.email, label, options)
  end

  # Copied from https://gist.github.com/1205828
  # Based on https://gist.github.com/1182136
  class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
  end

  def page_navigation_links(pages)
    will_paginate(pages, :class => 'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe)
  end

  # routines originally in activo-rails or mmenu. now rewritten for bootstrap

  def controls
    buttons = []
    content_tag(:div, class: 'action-buttons') do
      yield buttons
      buttons.join.html_safe
    end
  end

  def secondary_navigation
    links = []
    content_for :secondary_navigation do
      content_tag(:ul, class: 'nav nav-list') do
        yield links
        links.map { |link| content_tag(:li, link) }.join.html_safe
      end
    end
  end

  def list_icon(label = 'List')
    icon_label('th-list', label)
  end

  def envelope_icon(label = 'Email')
    icon_label('envelope', label)
  end

  def map_icon(label = 'Map')
    icon_label('map-marker', label)
  end

  def edit_icon(label = 'Edit')
    icon_label('edit', label)
  end

  def refresh_icon(label = 'Refresh')
    icon_label('refresh', label)
  end

  def icon(name)
    name = "glyphicon glyphicon-#{name}"
    content_tag(:i, nil, class: name)
  end

  def icon_label(name, label)
    icon(name) + " #{label}"
  end

  def td_colorize(count, extra_class = '')
    color = count > 0 ? 'dot-green' : 'dot-red'
    css_class = "#{extra_class} #{color}"
    content_tag(:td, count, class: css_class)
  end
end

