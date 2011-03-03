class Notifier < ActionMailer::Base
  def public_signup_received(public_signup)
    configure_smtp_settings
    text_attr = {
      :person_name => public_signup.registration.full_name,
      :event_name => public_signup.registration.event_name
    }
    header_attr = default_attributes
    header_attr[:to] = public_signup.registration.email
    header_attr[:subject] = I18n.translate('email.public_signup_received.subject',
                                           text_attr)
    mail(header_attr) do |format|
      format.text { render :text => I18n.translate('email.public_signup_received.body',
                                                   text_attr) }
    end
  end

  def registration_confirmed(registration)
    configure_smtp_settings
    text_attr = {
      :person_name => registration.full_name,
      :event_name => registration.event_name
    }
    header_attr = default_attributes
    header_attr[:to] = registration.email
    header_attr[:subject] = I18n.translate('email.registration_confirmed.subject',
                                           text_attr)
    mail(header_attr) do |format|
      format.text { render :text => I18n.translate('email.registration_confirmed.body',
                                                   text_attr) }
    end
  end

  private
  
  def configure_smtp_settings
    ActionMailer::Base.smtp_settings = Site.smtp_settings
  end

  def default_attributes
    { :from => from, :bcc => bcc }
  end
  
  def from
    "HAI Registrations <#{ActionMailer::Base.smtp_settings[:user_name]}>"
  end
  
  def bcc
    ActionMailer::Base.smtp_settings[:user_name]
  end

end
