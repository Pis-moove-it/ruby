class UsersController < ApplicationController
  def index
    render json: organization.users
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors, status: :bad_request
    end
  end

  def show
    render json: user_by_id
  end

  private

  def user_by_id
    @user_by_id ||= User.find(params[:id])
  end

  def organization
    @organization ||= Organization.find(params[:organization_id])
  end

  def user_params
    params.require(:user).permit(:ci, :name, :surname, :email, :organization_id)
  end
end