class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    friend_ids = current_user.friends.pluck(:id)
    @users = User.where(id: friend_ids)
    @messages = Message.where(sender: current_user).or(Message.where(receiver: current_user)).order(created_at: :desc)
  end

  def new
    friend_ids = current_user.friends.pluck(:id)
    @users = User.where(id: friend_ids)
    @message = Message.new
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    if @message.save
      redirect_to messages_path, notice: 'Message was successfully sent.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @other_user = User.find(params[:id])
    @messages = Message.where(sender: current_user, receiver: @other_user)
                       .or(Message.where(sender: @other_user, receiver: current_user))
                       .order(created_at: :asc)
    @new_message = current_user.sent_messages.build(receiver: @other_user)
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :body)
  end
end