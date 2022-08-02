class UsersController < ApplicationController
  before_action :user_admin, only: [:index]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @users = User.page(params[:page]).per(6)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
  end

  def edit
    @user = User.find(params[:id])
    if !current_user.admin?
      if @user.id != current_user.id
        redirect_to root_path
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path
    else
      render "edit"
    end
  end

  def reject_user
    @user = User.find(params[:id])
    #banする為に最初にアドミンか確認する
    if current_user.admin
      # 会員のis_validを反転する
      if @user.is_valid
        @user.update(is_valid: false)
      else
        @user.update(is_valid: true)
      end
      redirect_to users_path
    else
      redirect_to root_path
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
    end
  end
end
