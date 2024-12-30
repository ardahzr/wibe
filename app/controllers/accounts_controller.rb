class AccountsController < ApplicationController
  def show
    @user = current_user
  end

  def show_post
    @post = Post.find(params[:id])
  end
end