class UsersController < ApplicationController
  def index
    # @users = User.where.not(id: current_user.id)
    @users = User.all
  end
  def show
    @user = User.find(params[:id])
    @followers = @user.followers
    @followed_users = @user.followed_users
  end
end
