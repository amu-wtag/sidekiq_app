class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      SendWelcomeEmailJob.perform_async(@user.id)
      redirect_to root_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def delete
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
