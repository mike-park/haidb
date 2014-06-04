class Office::MessagesController < Office::ApplicationController
  def new
    @message = Message.new(from: current_staff.email,
                           header: SiteDefault.get('email.html.header'),
                           footer: SiteDefault.get('email.html.footer'))
  end

  def create
    @message = Message.new(message_params)
    if @message.valid?
      Messenger.email(@message).deliver
      redirect_to(new_office_message_path, notice: 'Message sent')
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:to_list, :bcc_list, :cc_list, :subject, :message, :from, :header, :footer)
  end
end