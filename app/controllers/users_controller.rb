class UsersController < ApplicationController

  def edit
  end

  def update
    if no_changes?(user_params)
      redirect_to root_path
      return
    end

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

  def no_changes?(params)
    nickname_same = params[:nickname] == current_user.nickname
    email_same    = params[:email]    == current_user.email
    password_blank = params[:password].blank? && params[:password_confirmation].blank?

    nickname_same && email_same && password_blank
  end

end