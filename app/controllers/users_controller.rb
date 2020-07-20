class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, only: :destroy
  PER = 24

  def index
    @users = User.with_attached_avatar.page(params[:page]).per(PER).order(:id)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @favorite_posts = @user.favorite_posts
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "ユーザーの削除が完了しました"
    redirect_to users_path
  end

  def follows
    user = User.find(params[:id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
