class Office::MessagesController < Office::ApplicationController

  def index
    @messages = Message.by_most_recent
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new(from: current_staff.email,
                           source_id: params[:source_id],
                           source_type: params[:source_type],
                           to_list: params[:to_list] || current_staff.email,
                           bcc_list: params[:bcc_list],
                           cc_list: params[:cc_list],
                           header: SiteDefault.get('email.html.header'),
                           footer: SiteDefault.get('email.html.footer'))
  end

  def create
    @message = Message.new(message_params)
    @message.staff = current_staff
    if @message.save
      Messenger.email(@message).deliver
      redirect_to(office_messages_path, notice: 'Message sent')
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:source_id, :source_type, :to_list, :bcc_list, :cc_list, :subject,
                                    :message, :from, :header, :footer)
  end
end