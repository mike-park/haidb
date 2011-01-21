class Notifier < ActionMailer::Base
  default :from => "HAI Registrations <registrations@haidb.info>",
          :bcc => 'registrations@haidb.info'
  

  def public_signup_received(public_signup)
    @full_name = public_signup.registration.full_name
    @event = public_signup.registration.event_name
    mail(:to => public_signup.registration.email,
         :subject => I18n.translate('actionmailer.notifier.public_signup_received')
         )
  end

  def registration_confirmed(registration)
    @full_name = registration.full_name
    @event = registration.event_name
    mail(:to => registration.email,
         :subject => I18n.translate('actionmailer.notifier.registration_confirmed',
                                    :event => @event)
         )
  end
end
