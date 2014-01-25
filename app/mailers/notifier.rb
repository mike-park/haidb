class Notifier < ActionMailer::Base

  helper :application

  def registration_with_template(registration, template)
    registration = registration.decorate
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
        'registration_code' => registration.registration_code,
        'cost' => registration.cost
    }
  end

  def mail_attributes(registration)
    { :from => from, :bcc => bcc, to: registration.email }
  end

  def from
    "HAI Registrations <#{default_address}>"
  end
  
  def bcc
    default_address
  end

  def default_address
    SiteDefault.get('email.registrations.from_address')
  end
end
