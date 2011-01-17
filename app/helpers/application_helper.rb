module ApplicationHelper
  ROW_COUNT_SELECTION = [5, 10, 30, 200]

  def options_for_row_count
    list = ROW_COUNT_SELECTION.map {|r| ["#{r} per page", r]}
    rows = params[:rows] || 10
    options_for_select(list, rows)
  end

  # redundent when we use metasearch
  def XXXsort_link_to(label, args = {})
    label = label.to_s
    prev_order = params[:sord] || 'asc'
    curr_order = nil
    if params[:sidx] && params[:sidx] == label
      curr_order = prev_order == 'asc' ? 'desc' : 'asc'
    end

    args.merge!(:sidx => label, :q => params[:q], :sord => curr_order,
                :rows => params[:rows])
    link_to(new_label(label, curr_order), url_for(args))
  end
  
  # return positive tick if field is considered true
  def checkmark_if(field)
    '&#10003;'.html_safe if !!field
  end

  ICON_SIZE='16x16'

  # generate edit link with icon
  def link_to_edit(path)
    link_to icon(:pencil, :small, :alt => 'Edit'), path
  end

  # show link with icon
  def link_to_show(path)
    link_to icon(:magnifier, :small, :alt => 'Show'), path
  end

  # show link with icon
  def link_to_new(path)
    link_to icon(:add, :small, :alt => 'Add'), path
  end

  # destroy link with icon
  def link_to_destroy(path)
    link_to icon(:delete, :small, :alt => 'Delete'), path, 
    :confirm => 'Are you sure?', :method => :delete
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
