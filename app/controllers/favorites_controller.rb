class FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)

    if favorite.save
      #通知
      @post.create_notification_favorite!(current_user)
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end
end
