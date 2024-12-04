class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    friend_ids = current_user.friends.pluck(:id)
    @users = User.where(id: friend_ids)
    @messages = Message.where(sender: current_user).or(Message.where(receiver: current_user)).order(created_at: :desc)
  end

  def show
    @other_user = User.find_by(id: params[:id])
    
    unless @other_user
      respond_to do |format|
        format.html { redirect_to messages_path }
        format.js { render js: "alert('User not found');" }
      end
      return
    end

    @messages = Message.where(
      "((sender_id = :current_user_id AND receiver_id = :other_user_id) OR (sender_id = :other_user_id AND receiver_id = :current_user_id))",
      current_user_id: current_user.id,
      other_user_id: @other_user.id
    ).order(:created_at)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    if @message.save
      redirect_to messages_path, notice: 'Message was sent successfully.'
    else
      redirect_to messages_path, alert: 'Message could not be sent.'
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :body)
  end
end