class UsersController < ApplicationController

  before_filter :load_user
  before_filter :check_user, only: [:edit, :update]


   def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_url, notice: 'Your account was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

    def check_user
      if current_user != User.find(params[:id])
        redirect_to root_url, alert: "Sorry, please sign in to access your seller profile page."
      end
    end


  def user_params
    params.require(:user).permit(:bankaccname)
  end
end