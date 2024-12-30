# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    if user_signed_in?
      @messages = Message.where(sender: current_user).or(Message.where(receiver: current_user))
    end
  end
end
