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

  def options_for_payment_method(form)
    choices = Registration::PAYMENT_METHODS.map do |method|
      [I18n.t("enums.registration.payment_method.#{method.downcase}"), method]
    end
    { :as => :radio, :collection => choices }
  end

  def options_for_role(form)
    { :as => :select, :prompt => 'Select ...', :collection => Registration::ROLES }
  end

  def options_for_status(form)
    { :as => :radio, :collection => Registration::STATUSES }
  end

  def options_for_backjack_rental(form)
    choices = [[I18n.t('enums.registration.backjack_rental.none'), false],
               [I18n.t('enums.registration.backjack_rental.rent'), true]]
    { :as => :radio, :collection => choices }
  end

  def options_for_lift(form)
    choices = [[I18n.t(:'enums.registration.lift.na'), ''],
               [I18n.t(:'enums.registration.lift.offered'),
                Registration::LIFTS.first],
               [I18n.t(:'enums.registration.lift.requested'),
                Registration::LIFTS.last]]
    { :as => :radio, :collection => choices}
  end

  def options_for_sunday_choice(form)
    choices = [[I18n.t('enums.registration.sunday_choice.none'),
                ''],
               [I18n.t(:'enums.registration.sunday_choice.meal'),
                Registration::SUNDAY_CHOICES.first],
               [I18n.t(:'enums.registration.sunday_choice.stayover'),
                Registration::SUNDAY_CHOICES.last]]
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

  def registration_payment_details(registration)
    return if registration.payment_method.blank?
    render 'office/registrations/show_payment', :registration => registration
  end

end
