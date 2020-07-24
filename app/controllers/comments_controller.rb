class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = @post.id
    respond_to do |format|
      if @comment.save
        @post.create_notification_comment(current_user, @comment.id)
        format.js { render :show_comments }
      else
        flash.now[:alert] = '投稿に失敗しました'
        format.js { render :show_comments }
      end
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    @comment.destroy
    render :show_comments
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :user_id)
  end
end
