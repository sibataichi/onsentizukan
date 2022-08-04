class GenresController < ApplicationController
  before_action :user_admin

  def index
    @genre = Genre.new
    @genres = Genre.all
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def create
    genre = Genre.new(genre_params)
    genre.save
    redirect_to genres_path
  end

  def update
    genre = Genre.find(params[:id])
    genre.update(genre_params)
    redirect_to genres_path
  end

  def destroy
    genre = Genre.find(params[:id])
    genre.destroy
    redirect_to genres_path
  end

  private
  
  def genre_params
    params.require(:genre).permit(:name)
  end

  def user_admin
    if current_user.admin == false
      redirect_to root_path
    end
  end
end
