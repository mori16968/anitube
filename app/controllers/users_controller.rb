class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, only: :destroy
  MAX_PER_PAGE = 24

  def index
    @users = User.with_attached_avatar.page(params[:page]).per(MAX_PER_PAGE).order(:id)
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(MAX_PER_PAGE).order(:id)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
    @favorite_posts = @user.favorite_posts.order(created_at: :desc)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "ユーザーの削除が完了しました"
    redirect_to users_path
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
