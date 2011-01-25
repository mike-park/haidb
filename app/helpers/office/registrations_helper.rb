module Office::RegistrationsHelper

  def options_for_terms_and_conditions(form)
    { :as => :boolean,
      :wrapper_html => {:style => 'padding-left: 0;'}
    }
  end
  
  def options_for_note(form)
    { :label => false, :input_html => {:cols => nil, :rows => 5} }
  end

  def options_for_signup_events_select(form)
    { :as => :select, :prompt => I18n.t(:'enums.select'),
      :collection => form.object.new_record? ? Event.upcoming :
      Event.reverse_date_order
    }
  end

  def options_for_special_diet(form)
    choices = [[I18n.t('enums.registration.special_diet.none'), false],
               [I18n.t('enums.registration.special_diet.vegie'), true]]
    { :as => :radio, :collection => choices }
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
    { :as => :radio, :collection => choices }
  end

  def options_for_role(form)
    { :as => :select, :prompt => 'Select ...', :collection => Registration::ROLES }
  end

  def options_for_status(form)
    { :as => :radio, :collection => Registration::STATUSES }
  end

  def options_for_backjack_rental(form, options = {})
    options.reverse_merge! :translate => true
    if options[:translate]
      choices = [[I18n.t('enums.registration.backjack_rental.none'), false],
                 [I18n.t('enums.registration.backjack_rental.rent'), true]]
    else
      choices = [['No', false], ['Yes', true]]
    end
    { :as => :radio, :collection => choices }
  end

  def options_for_lift(form)
    choices = [[I18n.t(:'enums.registration.lift.na'), ''],
               [I18n.t(:'enums.registration.lift.offered'),
                Registration::OFFERED],
               [I18n.t(:'enums.registration.lift.requested'),
                Registration::REQUESTED]]
    { :as => :radio, :collection => choices}
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
    { :as => :radio, :collection => choices }
  end

  # return a delimited list of requests in string form
  def registration_requests(registration, delimiter = ", ")
    requests = []
    requests << "backjack rental" if registration.backjack_rental?
    requests << "vegetarian diet" if registration.special_diet?
    requests << "sunday stayover" if registration.sunday_stayover?
    requests << "sunday meal" if registration.sunday_meal?
    requests << "lift #{registration.lift.downcase}" unless registration.lift.blank?
    requests.join(delimiter).html_safe
  end

end
