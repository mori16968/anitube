class FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    favorite = current_user.favorites.build(post_id: params[:post_id])
    favorite.save
    post = Post.find(params[:post_id])
    post.create_notification_favorite(current_user)
    redirect_to posts_path
  end

  def destroy
    favorite = Favorite.find_by(post_id: params[:post_id], user_id: current_user.id)
    favorite.destroy
    redirect_to posts_path
  end
end
