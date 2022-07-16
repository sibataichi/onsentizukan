class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to posts_path
  end

  def index
    if params[:search] == nil || params[:search] == ''
      @posts= Post.all
    else
      @posts = Post.joins(:user).where(["body LIKE(?) OR title LIKE(?) OR name LIKE(?)",'%' + params[:search] + '%','%' + params[:search] + '%','%' + params[:search] + '%'])
    end
  end

  def maps
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    @post = Post.find(params[:id])
    @post.delete
    redirect_to posts_path
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path
  end


  private

  def post_params
    params.require(:post).permit(:image, :title, :body, :address, :latitude, :longitude,)
  end

  def article_params
    params.require(:article).permit(:body, tag_ids: [])
  end
end
