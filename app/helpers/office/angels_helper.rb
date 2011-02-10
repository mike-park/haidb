module Office::AngelsHelper

  def options_for_gender(form)
    choices = [[I18n.t(:'enums.angel.gender.female'), Angel::FEMALE],
               [I18n.t(:'enums.angel.gender.male'), Angel::MALE]]
    { :as => :radio, :label => 'Gender', :required => true,
      :collection => choices}
  end

  def options_for_country(form)
    Carmen.default_locale = I18n.locale
    defaults = if I18n.locale.to_s == 'de'
                 %w(DE AT NL GB)
               else
                 %w(GB)
               end
    { :priority_countries => defaults }
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
  def compact_address(a, separator = tag(:br))
    code = (a.country || Carmen.default_country || '').strip.upcase
    address = if %w(US GB).include?(code)
                h("#{a.address}\n#{a.city}\n#{a.postal_code}")
              elsif %w(AU CA).include?(code)
                h("#{a.address}\n#{a.city} #{a.postal_code}")
              else
                h("#{a.address}\n#{a.postal_code} #{a.city}")
              end
    if (code != Carmen.default_country) &&
        (country = Carmen.country_name(code, :locale => I18n.locale))
      address << "\n#{country}"
    end
    address.gsub("\n", separator).html_safe
  end

  def compact_phones(angel, separator = tag(:br))
    phones = []
    %w(home mobile work).each do |ph|
      number = angel.read_attribute("#{ph}_phone")
      unless number.blank?
        label = t("enums.registration.roster.#{ph}")
        phones << h("#{label}: #{number}")
      end
    end
    phones.join(separator).html_safe
  end
    
  def angel_controls
    controls do |c|
      add_button_to(c, "Map", params.merge(:action => :map, :icon => 'map_magnify'))
      add_button_to(c, "VCard", params.merge(:format => :vcard, :icon => 'vcard'))
      add_button_to(c, "XLS", params.merge(:format => :xls, :icon => 'page_excel'))
      yield c if block_given?
    end
  end

  def no_angels_on_map(height = '400px')
    content_tag(:div, :style => "width: 100%; line-height: #{height};") do
      content_tag(:h2, :style => 'text-align: center; font-size: 30px; background: white; color: white; text-shadow: black 0px 0px 2px;') do
        "No angels match your search criteria"
      end
    end
  end
end
