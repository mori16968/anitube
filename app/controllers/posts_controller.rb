class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  def new
    @post = Post.new
  end

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
    @favorites = @post.favorites
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    url = params[:post][:youtube_url]
    url = url.last(11)
    @post.youtube_url = url
    if @post.save
      redirect_to posts_path
    else
      render 'posts/new'
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.user_id == current_user.id
      post.destroy
      redirect_to posts_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :title)
  end
end
