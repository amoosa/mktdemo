class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user! 
  before_action :check_user, only: [:edit, :update, :show]
 
  
  # GET /orders
  # GET /orders.json

  def sales
    @orders = Order.where(seller: current_user).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
         respond_to do |format|
         format.html
         format.csv { send_data @orders.to_csv(@orders) }  
      end
  end

  def purchases
    @orders = Order.where(buyer: current_user).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
  end

  def thankyou
  end

  def show
  end


    # GET /orders/new
  def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])
  end


   # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user

    @order.listing_id = @listing.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => (@listing.price * 100).floor,
        :currency => "usd",
        :card => token,
        :description => "Charge from OutfitAdditions"
        )
      #flash[:notice] = "Thank you for your order!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end

  transfer = Stripe::Transfer.create(
      :amount => (@listing.price * 80).floor, #converting to cents per stripe requirement. 80 percent in cents goes to seller.
      :currency => "usd",
      :recipient => @seller.recipient,
      :description => "Transfer from OutfitAdditions"
      )

    respond_to do |format|
      if @order.save
        format.html { redirect_to thankyou_url }
        format.json { render action: 'show', status: :created, location: @order }
        AutoNotifier.orderconf_email(current_user, @order).deliver #activate after paid sub to heroku
        AutoNotifier.sellerconf_email(current_user, @seller, @order).deliver #activate after paid sub to heroku
        #and adding sendgrid app to send email on heroku
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
  end
end

  def shipconf
      @order = Order.find(params[:id])
      AutoNotifier.shipconf_email(@order).deliver
  end

  def update
    respond_to do |format|
    if @order.update(order_params)
      format.html { redirect_to(sales_url, :notice => 'Order was successfully updated.') }
      format.json { respond_with_bip(@order) }
    else
      format.html { render :action => "edit" }
      format.json { respond_with_bip(@order) }
    end
  end
end
   

private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:shipname, :shipcompany,:shipaddress, :shipaddress2, :shipcity, :shipstate, 
                                    :shipzip, :cardname, :address, :address2, :city, :state, :zip, :comments,
                                     :tracking, :carrier)
    end

    def check_user
      if current_user.id != @order.seller_id && current_user.name != "admin admin"
        redirect_to root_url, alert: "Sorry, you are not the seller of this listing"
      end
    end

end
