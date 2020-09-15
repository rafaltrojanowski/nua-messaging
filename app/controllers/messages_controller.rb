class MessagesController < ApplicationController

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    @create_message = Messages::Create.new.call(message_params)

    if @create_message.success?
      redirect_to @create_message.message
    else
      @message = @create_message.message
      render "new"
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end

end
