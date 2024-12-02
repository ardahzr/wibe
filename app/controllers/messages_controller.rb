# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message.where(sender: current_user).or(Message.where(receiver: current_user))
    @users = User.where.not(id: current_user.id)
  end

  def show
    @other_user = User.find(params[:id])
    @messages = Message.where(sender: [current_user, @other_user], receiver: [current_user, @other_user])
    @new_message = Message.new(receiver: @other_user)
  end

  def new
    @message = Message.new
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    if @message.save
      redirect_to message_path(@message.receiver), notice: 'Message sent!'
    else
      redirect_back fallback_location: messages_path, alert: 'Message could not be sent.'
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :body)
  end
end
