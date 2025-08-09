class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update_with_password(user_params)
      bypass_sign_in(current_user)
      redirect_to root_path, notice: "ユーザー情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private 
  
  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation, :current_password)
  end
end