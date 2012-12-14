class Notifier < ActionMailer::Base

  def registration_with_template(registration, template)
    attr = mail_attributes(registration)
    attr[:subject] = render_template(registration, template.subject)
    mail(attr) do |format|
      format.text { render :text => render_template(registration, template.body) }
    end
  end

  private

  def render_template(registration, string)
    Liquid::Template.parse(string).render(template_fields(registration))
  end

  def template_fields(registration)
    {
        'person_name' => registration.full_name,
        'event_name' => registration.event_name,
    }
  end

  def mail_attributes(registration)
    { :from => from, :bcc => bcc, to: registration.email }
  end

  def from
    "HAI Registrations <#{Site.from_email}>"
  end
  
  def bcc
    Site.from_email
  end
end
