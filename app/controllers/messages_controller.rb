class MessagesController < ApplicationController

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params.merge(
      outbox: User.current.outbox,
      inbox: User.default_doctor.inbox,
    ))
    if @message.save
      redirect_to @message
    else
      render "new"
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end

end
