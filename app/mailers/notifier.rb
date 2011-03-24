class Notifier < ActionMailer::Base
  def public_signup_received(public_signup)
    mail_for('public_signup_received', {
               :person_name => public_signup.registration.full_name,
               :event_name => public_signup.registration.event_name,
               :to => public_signup.registration.email })
  end

  def registration_confirmed(registration)
    mail_for('registration_confirmed', {
               :person_name => registration.full_name,
               :event_name => registration.event_name,
               :to => registration.email })
  end

  private

  def mail_for(action, attr)
    subject = I18n.translate("email.#{action}.subject", attr)
    body = I18n.translate("email.#{action}.body", attr)
    mail(default_attributes.merge(:to => attr[:to],
                                  :subject => subject)) do |format|
      format.text { render :text => body }
    end
  end
  
  def default_attributes
    { :from => from, :bcc => bcc }
  end
  
  def from
    "HAI Registrations <#{Site.from_email}>"
  end
  
  def bcc
    [Site.from_email, "#{Site.name}-emails@t.quake.net"]
  end

end
