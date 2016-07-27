class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def create
    @message = Message.new message_params
    @message.ip = request.remote_ip
    @message.save!
    ActionCable.server.broadcast 'messages',
      message: @message.content,
      ip: @message.ip
    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
