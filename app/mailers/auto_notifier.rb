class AutoNotifier < ActionMailer::Base
  default from: "Outfit Additions"

  def orderconf_email(current_user)
  	    @customer = current_user.name
  	    #@item = @order.city
  	    #@itemprice = @listing.price
	    @url  = 'http://mktdemo.herokuapp.com/users/sign_up'
	    mail(to: current_user.email, bcc: "ashfaaqmoosa@gmail.com", subject: 'Thank you for your order.')
  end

end
