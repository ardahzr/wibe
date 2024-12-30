class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: [:update, :destroy]

  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id], confirmed: false)
    
    if @friendship.save
      flash[:notice] = "Friend request sent"
    else
      flash[:alert] = @friendship.errors.full_messages.join(", ")
    end
    redirect_to users_path
  end

  def update
    if @friendship&.update(confirmed: true)
      # Create reverse friendship
      Friendship.create(
        user_id: @friendship.friend_id,
        friend_id: @friendship.user_id,
        confirmed: true
      )
      flash[:notice] = "Friend request accepted"
    else
      flash[:alert] = "Could not accept friend request"
    end
    redirect_to users_path
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    friend = @friendship.friend
    user = @friendship.user

    # Find and destroy both sides of the friendship
    Friendship.where('(user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)', 
                    user.id, friend.id, friend.id, user.id).destroy_all

    flash[:notice] = "Friendship removed"
    redirect_to users_path
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
