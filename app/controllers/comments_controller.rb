class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      @post.create_notification_comment(current_user, @comment.id)
      redirect_back(fallback_location: root_url)
    else
      render 'posts/show'
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
