class UsersController < ApplicationController
  PER = 8

  def index
    @users = User.with_attached_avatar.page(params[:page]).per(PER).order(:id)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @favorite_posts = @user.favorite_posts
  end

  def follows
    user = User.find(params[:id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end
end
