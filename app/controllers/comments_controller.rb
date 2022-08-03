class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = post.id
    @comment_post = @comment.post
    if @comment.save
      @comment_post.create_notification_comment!(current_user, @comment.id)
      redirect_to post_path(post)
    else
      redirect_to post_path(post)
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    if !current_user.admin?
      if @comment.user_id != current_user.id
        redirect_to post_path(params[:post_id])
      else
        @comment.destroy
        redirect_to post_path(params[:post_id])
      end
    else
      @comment.destroy
      redirect_to post_path(params[:post_id])
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
