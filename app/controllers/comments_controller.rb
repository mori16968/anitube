class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      @post.create_notification_comment(current_user, @comment.id)
      flash[:success] = "コメントを投稿しました"
      redirect_back(fallback_location: root_url)
    else
      redirect_to post_path(@post.id)
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_back(fallback_location: root_url)
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :user_id)
  end
end
