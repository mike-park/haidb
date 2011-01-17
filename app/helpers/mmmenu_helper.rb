module MmmenuHelper

  def build_mmmenu(menu, div_class = 'main-navigation')
    menu.item_markup(0, :active_markup => {:class => :active}) do |link, text, options|
      content_tag(:li, link_to(text, link, options[:html]), options[:active])
    end
    menu.level_markup(0) do |menu|
      content_tag(:div, :class => div_class) do
        content_tag(:ul, menu, {:class => 'wat-cf'}, false)
      end
    end
    menu.build.html_safe
  end

end
