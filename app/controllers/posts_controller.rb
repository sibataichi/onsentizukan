class PostsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show, :maps, :genre_search]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def index
    if params[:search] == nil || params[:search] == ''
      @posts= Post.order(created_at: :desc).page(params[:page])
      @genres = Genre.all
    else
      @posts = Post.joins(:user)
      .where(["body LIKE(?) OR title LIKE(?) OR name LIKE(?) OR address LIKE(?)",'%' + params[:search] + '%','%' + params[:search] + '%','%' + params[:search] + '%','%' + params[:search] + '%'])
      .order(created_at: :desc).page(params[:page])
      @genres = Genre.all
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
    #if文でアドミンとユーザー以外検証ツールで削除できないように
    if !current_user.admin?
      if @post.user_id != current_user.id
        redirect_to posts_path
      else
        @post.delete
        redirect_to posts_path
      end
    else
      @post.delete
      redirect_to posts_path
    end
  end

  def edit
    @post = Post.find(params[:id])
    if !current_user.admin?
      if @post.user_id != current_user.id
        redirect_to root_path
      end
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path
    else
      render :edit
    end
  end

  def genre_search
    @genres = Genre.all
    posts = Post.genre_search(params[:genre_id])
    @posts= posts.order(created_at: :desc).page(params[:page])
    @genre_name = Genre.find(params[:genre_id]).name
  end

  private

  def post_params
    params.require(:post).permit(:image, :title, :body, :address, :latitude, :longitude, :genre_id)
  end
end
