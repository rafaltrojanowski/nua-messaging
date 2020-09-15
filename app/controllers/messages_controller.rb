class MessagesController < ApplicationController

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    original_message_id = params[:original_message_id]
    @create_message = Messages::Create.new.call(
      attrs: message_params, 
      original_message_id: original_message_id
    )

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
