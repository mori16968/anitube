class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = @post.id
    @comment.save
    redirect_back(fallback_location: root_url)
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
