
class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id], status: :pending)
    if @friendship.save
      flash[:notice] = "Friend request sent"
    else
      flash[:alert] = "Could not send friend request"
    end
    redirect_to users_path
  end

  def update
    @friendship = Friendship.find(params[:id])
    if params[:status] == "accepted"
      @friendship.accepted!
      flash[:notice] = "Friend request accepted"
    elsif params[:status] == "rejected"
      @friendship.rejected!
      flash[:notice] = "Friend request rejected"
    end
    redirect_to users_path
  end

  def destroy
    @friendship = Friendship.find_by(id: params[:id])
    if @friendship.destroy
      flash[:notice] = "Removed friendship"
    end
    redirect_to users_path
  end
end