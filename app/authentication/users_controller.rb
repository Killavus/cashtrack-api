class UsersController < ApplicationController
  def create
    register_user.(user_params[:email], user_params[:password])
    head :created
  rescue RegisterUser::AlreadyRegistered
    head :unprocessable_entity
  rescue RegisterUser::ValidationFailed
    head :unprocessable_entity
  end

  private
  def register_user
    RegisterUser.new
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end