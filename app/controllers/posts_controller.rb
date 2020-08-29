class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  MAX_PER_PAGE = 12

  def new
    @post = Post.new
  end

  def index
    @posts = Post.page(params[:page]).per(MAX_PER_PAGE).order(created_at: :desc)
    @videos = Video.all.limit(6)
  end

  def feed
    @feed_posts = current_user.feed.page(params[:page]).per(MAX_PER_PAGE).order(created_at: :desc)
  end

  def popular
    @popular_posts = Post.find(Favorite.group(:post_id).
      order('count(post_id) desc').
      pluck(:post_id))
    @popular_posts = Kaminari.paginate_array(@popular_posts).
      page(params[:page]).
      per(MAX_PER_PAGE)
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
      flash[:success] = "投稿が完了しました"
      redirect_to posts_path
    else
      render 'posts/new'
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.user_id == current_user.id
      post.destroy
      flash[:success] = "投稿の削除が完了しました"
      redirect_to posts_path
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = "投稿の編集が完了しました"
      redirect_to post_path(@post.id)
    else
      render 'posts/edit'
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :title, :youtube_url)
  end
end
