class UsersController < ApplicationController
  before_action :user_admin, only: [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path
    else
      render "edit"
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :profile)
  end

  def user_admin
    @users = User.all
    if  current_user.admin == false
      redirect_to root_path
    else
     render action: "index"
    end
  end

end
