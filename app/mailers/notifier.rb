class Notifier < ActionMailer::Base

  attr_accessor :registration

  def public_signup_received(public_signup)
    send_registration_email(EventEmail::SIGNUP, public_signup.registration)
  end

  def public_signup_waitlisted(public_signup)
    send_registration_email(EventEmail::PENDING, public_signup.registration)
  end

  def registration_confirmed(registration)
    send_registration_email(EventEmail::APPROVED, registration)
  end

  def send_registration_email(category, registration)
    self.registration = registration

    if template = email_template_of(category)
      attr = mail_attributes
      attr[:subject] = render_template(template.subject)
      mail(attr) do |format|
        format.text { render :text => render_template(template.body) }
      end
    else
      puts "no email template found: [#{registration.event_name}, #{category}, #{locale}]"
    end
  end

  private

  def email_template_of(category)
    registration.event.email(category, locale)
  end

  def locale
    registration.angel.lang || 'en'
  end

  def render_template(template)
    Liquid::Template.parse(template).render(template_fields)
  end

  def template_fields
    {
        'person_name' => registration.full_name,
        'event_name' => registration.event_name,
    }
  end

  def mail_attributes
    { :from => from, :bcc => bcc, to: to }
  end

  def to
    registration.email
  end

  def from
    "HAI Registrations <#{Site.from_email}>"
  end
  
  def bcc
    [Site.from_email, "#{Site.name}-emails@t.quake.net"]
  end

end
