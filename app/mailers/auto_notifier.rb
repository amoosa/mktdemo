class AutoNotifier < ActionMailer::Base
  default :from => '"Outfit Additions" <service@outfitadditions.com>'

  def orderconf_email(current_user, order)
  	    @buyer = current_user
  	    @order =  order
	    @url  = 'http://www.outfitadditions.com/users/sign_in'
	    mail(to: @buyer.email, bcc: "ashfaaqmoosa@gmail.com", subject: 'Thank you for your order.')
  end

  def sellerconf_email(current_user, seller, order)
  	    @seller = seller
  	    @order =  order
  	    @buyer = current_user
	    @url  = 'http://www.outfitadditions.com/users/sign_in'
	    mail(to: @order.seller.email, bcc: "ashfaaqmoosa@gmail.com", subject: 'You have a new order at Outfit Additions.')
  end

  def shipconf_email(order)
      @order =  order
      @url  = 'http://www.outfitadditions.com/users/sign_in'
      mail(to: @order.buyer.email, bcc: "ashfaaqmoosa@gmail.com", subject: 'Your order has been shipped.')
  end


end
