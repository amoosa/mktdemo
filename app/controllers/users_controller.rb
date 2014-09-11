class UsersController < ApplicationController

  before_filter :load_user
  before_filter :check_user, only: [:edit, :update, :sellerprofile]

def update
    @user.attributes = user_params
    Stripe.api_key = ENV["STRIPE_API_KEY"]
      token = params[:stripeToken]

      recipient = Stripe::Recipient.create(
        :name => user_params["bankaccname"], #if i want to save to db, use this: @user.bankaccname. not saving it                 
        :type => "individual",              #gives you only one set of error messages. i don't need the respond
        :bank_account => token              #to block either i think. eg. when i enter firstname only, i get two error
        )                                   #msgs

      @user.recipient = recipient.id

     respond_to do |format|
      if @user.save
        format.html { redirect_to edit_user_url, notice: 'Your account was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def sellerprofile
     @user.update_attributes(:profilestory => params[:profilestory], :profileimage => params[:profileimage])
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
    params.require(:user).permit(:bankaccname, :profileimage, :profilestory)
  end
end