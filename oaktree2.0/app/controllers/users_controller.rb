class UsersController < ApplicationController
# UsersController handles setting and updating timezones for the user.

  def edit
    @user = current_user
  end

  def update
    current_user.update(time_zone: params[:user][:time_zone])
    redirect_to root_path
  end

end
