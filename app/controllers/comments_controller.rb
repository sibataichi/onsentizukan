class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = post.id
    @comment_post = @comment.post
    if @comment.save
    @comment_post.create_notification_comment!(current_user, @comment.id)
    end
    redirect_to post_path(post)
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end


  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
