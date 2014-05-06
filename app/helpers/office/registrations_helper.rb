module Office::RegistrationsHelper

  def options_for_gender(form)
    choices = [[I18n.t(:'enums.registration.gender.female'), Registration::FEMALE],
               [I18n.t(:'enums.registration.gender.male'), Registration::MALE]]
    { :as => :radio_buttons, :label => 'Gender', :required => true,
      :collection => choices}
  end

  def options_for_lang(form)
    choices = [%w(Deutsch de), %w(English en)]
    { :as => :radio_buttons, :label => 'Language', :collection => choices}
  end

  def options_for_terms_and_conditions(form)
    { :as => :boolean }
  end
  
  def options_for_note(form)
    { :label => false, :input_html => {:cols => nil, :rows => 5} }
  end

  # HACK ALERT! this assumes simple_form
  def options_for_signup_events_select(form)
    { :as => :select, :prompt => I18n.t(:'enums.select'),
      :collection => Event.with_oldest_last,
      label_method: :display_name, value_method: :id
    }
  end

  def options_for_public_signup_events_select(form)
    { :as => :select, :prompt => I18n.t(:'enums.select'),
      :collection => Event.upcoming,
      label_method: :display_name, value_method: :id
    }
  end

  def options_for_payment_method(form, options = {})
    options.reverse_merge! :translate => true
    if options[:translate]
      choices = Registration::PAYMENT_METHODS.map do |method|
        [I18n.t("enums.registration.payment_method.#{method.downcase}"), method]
      end
    else
      choices = Registration::PAYMENT_METHODS
    end
    { :as => :radio_buttons, :collection => choices }
  end

  def options_for_role(form)
    { :as => :select, :prompt => 'Select ...', :collection => Registration::ROLES }
  end

  def options_for_status(form)
    { :as => :radio_buttons, :collection => Registration::STATUSES }
  end

  def options_for_backjack_rental(form, options = {})
    options.reverse_merge! :translate => true
    if options[:translate]
      choices = [[I18n.t('enums.registration.backjack_rental.none'), false],
                 [I18n.t('enums.registration.backjack_rental.rent'), true]]
    else
      choices = [['No', false], ['Yes', true]]
    end
    { :as => :radio_buttons, :collection => choices }
  end

  def options_for_lift(form)
    choices = [[I18n.t(:'enums.registration.lift.na'), ''],
               [I18n.t(:'enums.registration.lift.offered'),
                Registration::OFFERED],
               [I18n.t(:'enums.registration.lift.requested'),
                Registration::REQUESTED]]
    { :as => :radio_buttons, :collection => choices}
  end

  def options_for_sunday_choice(form, options = {})
    options.reverse_merge! :translate => true
    if options[:translate]
      choices = [[I18n.t('enums.registration.sunday_choice.none'),
                  ''],
                 [I18n.t(:'enums.registration.sunday_choice.meal'),
                  Registration::MEAL],
                 [I18n.t(:'enums.registration.sunday_choice.stayover'),
                  Registration::STAYOVER]]
    else
      choices = [['No', ''],
                 ['Yes', Registration::MEAL],
                 ['incl Stayover', Registration::STAYOVER]]
    end
    { :as => :radio_buttons, :collection => choices }
  end

  # return a delimited list of requests in string form
  def registration_requests(registration, delimiter = ", ")
    requests = []
    requests << "backjack rental" if registration.backjack_rental?
    requests << registration.special_diet if registration.special_diet.present?
    requests << "sunday stayover" if registration.sunday_stayover?
    requests << "sunday meal" if registration.sunday_meal?
    requests << "lift #{registration.lift.downcase}" unless registration.lift.blank?
    requests.join(delimiter).html_safe
  end

  def options_for_how_hear(form)
    { :label => 'How did you hear of HAI?',
      :as => :select,
      :prompt => 'Select ...',
      :collection => Registration::HOW_HEAR }
  end

  def options_for_previous_event(form)
    { :label => 'Have you attended a HAI event before?',
      :as => :select,
      :prompt => 'Select ...',
      :collection => Registration::PREVIOUS_EVENT }
  end

  def color_dot(state)
    content_tag(:span, "", class: "dot dot-#{state ? 'green' : 'red'}")
  end

  def label_state(text, state)
    content_tag(:span, text, class: "label label-#{state ? 'success' : 'danger'}")
  end

  def compact_address(object)
    code = object.country
    code ||= Site.de? ? 'DE' : 'GB'
    code = code.strip.upcase
    address = [object.address]
    address += if %w(US GB).include?(code)
                [object.city, object.postal_code]
              elsif %w(AU CA).include?(code)
                ["#{object.city} #{object.postal_code}"]
              else
                ["#{object.postal_code} #{object.city}"]
              end
    address = address.compact.reject(&:blank?)
    if address.any?
      country = Carmen::Country.coded(code)
      address += [country.name] if country
    end
    address.join("\n")
  end

  def compact_phones(object, with_link = true)
    phones = []
    %w(home mobile work).each do |ph|
      number = object.read_attribute("#{ph}_phone")
      unless number.blank?
        label = t("enums.registration.roster.#{ph}")
        value = with_link ? link_to(number, "tel:#{number}") : number
        phones << "#{label}: #{value}"
      end
    end
    phones.join("\n")
  end

  def span_phones(object)
    phones = []
    %w(home mobile work).each do |ph|
      number = object.send("#{ph}_phone")
      unless number.blank?
        label = t("enums.registration.roster.#{ph}")
        phones << content_tag(:span, "#{label}: #{number}", class: 'phone')
      end
    end
    phones.join("\n").html_safe
  end

  def compact_payment(object, text_only = false)
    separator = text_only ? "\n" : tag(:br)
    rows = []
    [:payment_method, :bank_account_name, :iban, :bic].each do |name|
      value = object.send(name)
      if value.present?
        label = t("formatastic.labels.#{name}")
        rows << "#{label}: #{value}"
      end
    end
    rows.join(separator).html_safe
  end
end
