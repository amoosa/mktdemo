class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:seller, :new, :create, :edit, :update, :destroy]
  before_filter :check_user, only: [:edit, :update, :destroy]

  # GET /listings
  # GET /listings.json

  def seller
    @listings = Listing.where(user: current_user).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
     respond_to do |format|
         format.html
         format.csv { send_data @listings.to_csv(@listings) }  
      end
  end

  def index
      @listings = Listing.not_expired.order("created_at DESC").paginate(:page => params[:page], :per_page => 48)  
      respond_to do |format|
         format.html
         format.csv { send_data @listings.to_csv(@listings) }   
       end
  end

  def category
    @category = params[:category]
    @listings = Listing.not_expired.where(:category => @category).paginate(:page => params[:page], :per_page => 48)
  end

  def admin
     if current_user.name == "admin admin"
        @listings = Listing.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
     else
        redirect_to root_url, notice: "Sorry, you are not authorized to view the admin page."
     end
  end

  def vendor
    @user = User.find(params[:id])
    @listings = Listing.not_expired.where(user: User.find(params[:id])).paginate(:page => params[:page], :per_page => 48)
  end

  def search
    @listings = Listing.not_expired.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
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
    @listing.user_id = current_user.id    

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
      Listing.import(params[:file], params[:user_id])
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
      if current_user.id != @listing.user_id && current_user.name != "admin admin"
        redirect_to root_url, alert: "Sorry, this listing belongs to someone else"
      end
    end
end


   