class Notifier < ActionMailer::Base

  helper :application

  def registration_with_template(registration, template, options = {})
    registration = registration.decorate
    unless options.has_key?(:from)
      options[:from] = "HAI Registrations <#{default_address}>"
    end
    options[:bcc] ||= options[:from]
    options[:to] = registration.email
    options[:subject] = render_template(registration, template.subject)
    mail(options) do |format|
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
        'cost' => registration.cost,
        'iban' => registration.iban,
        'bic' => registration.bic,
        'account_name' => registration.bank_account_name
    }
  end

  def default_address
    SiteDefault.get('email.registrations.from_address')
  end
end
