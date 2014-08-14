class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:seller, :new, :create, :edit, :update, :destroy]
  before_filter :check_user, only: [:edit, :update, :destroy]

  # GET /listings
  # GET /listings.json

  def seller
    @listings = Listing.where(userid: current_user).order("created_at DESC")
  end

  def index
      @listings = Listing.all.order("created_at DESC")
  end

  def admin
     if current_user.name == "admin admin"
        @listings = Listing.all.order("created_at DESC")
     else
        redirect_to root_url, notice: "Sorry, you are not authorized to view the admin page."
     end
  end

  def search
    @listings = Listing.search(params[:search]).order("created_at DESC")
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.userid = current_user.id

    
      Stripe.api_key = ENV["STRIPE_API_KEY"]
      token = params[:stripeToken]

      recipient = Stripe::Recipient.create(
        :name => current_user.name,
        :type => "individual",
        :bank_account => token
        )

      current_user.recipient = recipient.id
      current_user.save
    

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render action: 'show', status: :created, location: @listing }
      else
        format.html { render action: 'new' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    begin
      Listing.import(params[:file], params[:userid])
      redirect_to seller_url, notice: "Products imported."
    rescue
      redirect_to seller_url, notice: "Invalid CSV file format."
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:name, :description, :price, :inventory, :category, :sku, :image, :image2, 
                                      :image3, :image4, :featured)
    end

    def check_user
      if current_user.id != @listing.userid and current_user.name != "admin admin"
        redirect_to root_url, alert: "Sorry, this listing belongs to someone else"
      end
    end
end


   