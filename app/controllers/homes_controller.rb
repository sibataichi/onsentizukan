class HomesController < ApplicationController
  def top
  end

  def about
  end

  def unsubscribe
    @user = User.find(params[:user_id])
  end

  def withdraw
    @user = User.find(params[:user_id])
    @user.update(is_valid: false)
    reset_session
    redirect_to root_path
  end
end
