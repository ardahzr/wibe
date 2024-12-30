require 'net/http'
require 'uri'
require 'json'

class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy, :like, :unlike]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all
    @post = Post.new
    friend_ids = current_user.friends.pluck(:id)
    @posts = Post.where(user_id: [current_user.id, *friend_ids]).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    response = check_text_with_api(@post.content)
    if response[:class] != 2
      flash[:alert] = "Your post contains inappropriate content (Hate or Offensive) and cannot be saved."
      render :new, status: :unprocessable_entity
      return
    end

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  before_action :find_post, only: [:like, :unlike]

  def like
    @post.likes.create(user: current_user)
    respond_to do |format|
      format.js   
      format.html { redirect_to posts_path } 
    end
  end

  def unlike
    like = @post.likes.find_by(user: current_user)
    like.destroy if like
    respond_to do |format|
      format.js   
      format.html { redirect_to posts_path } 
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    redirect_to posts_path, alert: 'You are not authorized to perform this action.' unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :content, media: [])
  end

  def check_text_with_api(text)
    uri = URI.parse("http://127.0.0.1:5000/predict")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { 'Content-Type': 'application/json' })
    request.body = { text: text }.to_json

    begin
      response = http.request(request)
      result = JSON.parse(response.body)

      scores = {
        0 => result["Class 0"], # Hate
        1 => result["Class 1"], # Offensive
        2 => result["Class 2"]  # Normal
      }
      predicted_class = scores.max_by { |_, score| score }[0]

      { class: predicted_class }
    rescue StandardError => e
      Rails.logger.error("Error calling Flask API: #{e.message}")
      { class: 2 }
    end
  end
end
