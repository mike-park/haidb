module Office::AngelsHelper

  def options_for_gender(form)
    choices = [[I18n.t(:'enums.angel.gender.female'), Angel::FEMALE],
               [I18n.t(:'enums.angel.gender.male'), Angel::MALE]]
    { :as => :radio, :label => 'Gender', :required => true,
      :collection => choices}
  end

  def options_for_lang(form)
    choices = [%w(Deutsch de), %w(English en)]
    { :as => :radio, :label => 'Language', :collection => choices}
  end

  def options_for_angel_select(form)
    { :as => :select, :label => 'Angel', :collection => Angel.by_last_name }
  end
  
  # FIXME this doesn;t work until the address is urlencoded
  def link_to_map(angel)
    "FIXME"
    #link_to('Map', "http://maps.google.com/maps?q=#{compact_address(angel, ',')}", :target => '_blank')
  end

  # return address in html display format
  def compact_address(angel, separator = tag(:br))
    country = (angel.country || "").strip.downcase
    layout = 'UK' if ['uk','england','gb','great britain'].include?(country)
    address = case layout
              when 'UK'
                h(angel.address) + "\n" +
                  h(angel.city) + "\n" +
                  h(angel.postal_code) + "\n" +
                  h(angel.country)
              else
                h(angel.address) + "\n" +
                  h("#{angel.postal_code} #{angel.city}") + "\n" +
                  h(angel.country)
              end
    return '' if address.blank?
    address.gsub("\n", separator).html_safe
  end
  
 
  def compact_phones(angel, separator = tag(:br))
    phones = []
    %w(home mobile work).each do |ph|
      number = angel.read_attribute("#{ph}_phone")
      unless number.blank?
        phones << h("#{ph[0].capitalize}: #{number}")
      end
    end
    phones.join(separator).html_safe
  end

end
