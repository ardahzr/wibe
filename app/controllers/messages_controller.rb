class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    friend_ids = current_user.friends.where(friendships: { confirmed: true }).pluck(:id)
    @users = User.where(id: friend_ids)
    @messages = Message.where(sender: current_user).or(Message.where(receiver: current_user)).order(created_at: :desc)
    @last_messages = @users.map do |user|
      Message.where("(sender_id = :user_id AND receiver_id = :current_user_id) OR (sender_id = :current_user_id AND receiver_id = :user_id)", user_id: user.id, current_user_id: current_user.id).order(created_at: :desc).first
    end
  end

  def show
    @other_user = User.find_by(id: params[:id])

    unless @other_user
      respond_to do |format|
        format.html { redirect_to messages_path }
        format.js { render js: "alert('User not found');" }
        format.json { render json: { error: "User not found" }, status: :not_found }
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
      format.json { render json: { messages: @messages } }
    end
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    @other_user = User.find(message_params[:receiver_id])

    respond_to do |format|
      if @message.save
        format.html { redirect_to message_path(@other_user) }
        format.js   # Will use create.js.erb for JavaScript response
      else
        format.html { redirect_to message_path(@other_user), alert: "Message could not be sent." }
        format.js { render js: "alert('#{@message.errors.full_messages.join(', ')}');" }
      end
    end
  end

  def delete
    @message = Message.find(params[:id])
    @other_user = @message.sender == current_user ? @message.receiver : @message.sender

    if @message.sender == current_user
      @last_message = Message.where(
        "((sender_id = :user_id AND receiver_id = :other_id) OR (sender_id = :other_id AND receiver_id = :user_id)) AND id != :message_id",
        user_id: current_user.id,
        other_id: @other_user.id,
        message_id: @message.id
      ).order(created_at: :desc).first

      if @message.destroy
        respond_to do |format|
          format.html { redirect_to messages_path }
          format.js { render "delete", content_type: "text/javascript" }
          format.json { render json: { success: true } }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to messages_path, alert: "You can only delete your own messages." }
        format.js { render js: "alert('You can only delete your own messages.');", content_type: "text/javascript" }
        format.json { render json: { error: "You can only delete your own messages." }, status: :forbidden }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :body, :attachment)
  end
end
