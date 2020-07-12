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
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:success] =  "投稿が完了しました"
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

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update!(post_params)
    redirect_to post_path(post.id)
  end

  private

  def post_params
    params.require(:post).permit(:body, :title, :youtube_url)
  end
end
