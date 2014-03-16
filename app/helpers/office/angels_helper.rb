module Office::AngelsHelper

  def options_for_country(form)
    Carmen.default_locale = I18n.locale
    defaults = if I18n.locale.to_s == 'de'
                 %w(DE AT NL GB)
               else
                 %w(GB)
               end
    { :priority_countries => defaults }
  end

  # TODO fix
  def options_for_angel_select(form)
    { :as => :select, :label => 'Angel', :collection => Angel.by_full_name, label_method: :full_name_with_context, value_method: :id }
  end
  
  def no_angels_on_map(height = '400px')
    content_tag(:div, :style => "width: 100%; line-height: #{height};") do
      content_tag(:h2, :style => 'text-align: center; font-size: 30px; background: white; color: white; text-shadow: black 0px 0px 2px;') do
        "No angels match your search criteria"
      end
    end
  end

  def angel_membership_status(angel)
    membership = angel.memberships.active.first
    if membership
      content_tag(:i, membership.status)
    end
  end
end
