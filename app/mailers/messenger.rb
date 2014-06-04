class Messenger < ActionMailer::Base
  def email(message)
    attrs = [:to, :from, :cc, :bcc, :subject].inject({}) do |memo, name|
      memo.merge(name => message.send(name))
    end
    @header = message.header
    @body = message.message
    @footer = message.footer
    mail(attrs)
  end
end
