class Notifier < ActionMailer::Base

  helper :application

  def registration_with_template(registration, template, options = {})
    registration = registration.decorate
    fields = extract_fields(registration, options)
    unless options.has_key?(:from)
      options[:from] = "HAI Registrations <#{default_address}>"
    end
    options[:bcc] ||= options[:from]
    options[:to] = registration.email
    options[:subject] = render_template(template.subject, fields)
    mail(options) do |format|
      format.text { render :text => render_template(template.body, fields) }
    end
  end

  private

  def render_template(template, fields)
    Liquid::Template.parse(template).render(fields)
  end

  def extract_fields(registration, options)
    fields = [:event_name, :registration_code, :cost, :iban, :bic].inject({}) do |memo, field|
      memo.merge(field => registration.send(field))
    end
    fields[:person_name] = registration.full_name
    fields[:account_name] = registration.bank_account_name
    fields[:account_name] = registration.full_name if fields[:account_name].blank?
    fields.merge(options).stringify_keys
  end

  def default_address
    SiteDefault.get('email.registrations.from_address')
  end
end
