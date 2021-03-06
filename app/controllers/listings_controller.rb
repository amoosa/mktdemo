class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:seller, :new, :create, :edit, :update, :destroy]
  before_filter :check_user, only: [:edit, :update, :destroy]

  # GET /listings
  # GET /listings.json

  def index
      if params[:sort] == "- Price - Low to High"
        @listings = Listing.not_expired.order("price ASC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- Price - High to Low"
        @listings = Listing.not_expired.order("price DESC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- New Arrivals"
        @listings = Listing.not_expired.order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- Random Shuffle"
        @listings = Listing.not_expired.order("random()").paginate(:page => params[:page], :per_page => 48)
      else
        @listings = Listing.not_expired.order("random()").paginate(:page => params[:page], :per_page => 48)
      end

       respond_to do |format|
         format.html
         format.csv { send_data @listings.to_csv(@listings) }   
       end

      # @listings = Listing.not_expired.order("created_at DESC").paginate(:page => params[:page], :per_page => 48)  
      # respond_to do |format|
      #    format.html
      #    format.csv { send_data @listings.to_csv(@listings) }   
      #  end
        
  end

  def seller
    @listings = Listing.where(user: current_user).order("created_at DESC") #.paginate(:page => params[:page], :per_page => 48)
     respond_to do |format|
         format.html
         format.csv { send_data @listings.to_csv(@listings) }  
      end
  end

  def category
    @category = params[:category]
    #@listings = Listing.not_expired.where(:category => @category).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)

      if params[:sort] == "- Price - Low to High"
        @listings = Listing.not_expired.where(:category => @category).order("price ASC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- Price - High to Low"
        @listings = Listing.not_expired.where(:category => @category).order("price DESC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- New Arrivals"
        @listings = Listing.not_expired.where(:category => @category).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- Random Shuffle"
        @listings = Listing.not_expired.where(:category => @category).order("random()").paginate(:page => params[:page], :per_page => 48)
      else
        @listings = Listing.not_expired.where(:category => @category).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
      end

  end

   def sale
      if params[:sort] == "- Price - Low to High"
        @listings = Listing.not_expired.where("saleprice > ?", 0).order("price ASC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- Price - High to Low"
        @listings = Listing.not_expired.where("saleprice > ?", 0).order("price DESC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- New Arrivals"
        @listings = Listing.not_expired.where("saleprice > ?", 0).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- Random Shuffle"
        @listings = Listing.not_expired.where("saleprice > ?", 0).order("random()").paginate(:page => params[:page], :per_page => 48)
      else
        @listings = Listing.not_expired.where("saleprice > ?", 0).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
      end
  end

  def admin
     if current_user.name == "admin admin"
        @listings = Listing.not_expired.order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
     else
        redirect_to root_url, notice: "Sorry, you are not authorized to view the admin page."
     end
  end

  def vendor
    @user = User.find(params[:id])
    #@listings = Listing.not_expired.where(user: User.find(params[:id])).paginate(:page => params[:page], :per_page => 48)

      if params[:sort] == "- Price - Low to High"
        @listings = Listing.not_expired.where(user: User.find(params[:id])).order("price ASC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- Price - High to Low"
        @listings = Listing.not_expired.where(user: User.find(params[:id])).order("price DESC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- New Arrivals"
        @listings = Listing.not_expired.where(user: User.find(params[:id])).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
      elsif params[:sort] == "- Random Shuffle"
        @listings = Listing.not_expired.where(user: User.find(params[:id])).order("random()").paginate(:page => params[:page], :per_page => 48)
      else
        @listings = Listing.not_expired.where(user: User.find(params[:id])).order("created_at DESC").paginate(:page => params[:page], :per_page => 48)
      end

  end

  def search
    if params[:search].present?

      @listings = Listing.search(params[:search], where: { inventory: {gt: 0},
                                           or: [
                                                 [{updated_at: {gte: (Date.current - 30.day)}}, {user_id: 24}]
                                               ] })

     # @listings = Listing.search(params[:search], where: { inventory: {gt: 0} })
     else
      @listings = Listing.order("created_at DESC")
    end
  end

  def ownsearch
    if params[:search].present?
      @listings = Listing.where(user: current_user).ownsearch(params[:search])
     else
      @listings = Listing.where(user: current_user).order("created_at DESC")
    end
  end

  def show
    if request.path != listing_path(@listing)
      redirect_to @listing, status: :moved_permanently
    end
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
    ActionController::Base.new.expire_fragment("homepage_p#{params[:page]}_s_#{params[:sort]}", options = nil)
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

   ActionController::Base.new.expire_fragment("homepage_p#{params[:page]}_s_#{params[:sort]}", options = nil)

  end

  def check_listing_status
    user_listing = UserListing.find_by(user:current_user)
    render :json => -1 if user_listing.nil?
    unless user_listing.nil?
      @process_status = user_listing.process_status + 1
      render :json => @process_status - 1

      user_listing.listed! if user_listing.is_processed? or user_listing.is_failed?
   end



  end

 require 'fileutils'

  def import
    tmp = params[:my_file].tempfile

    #FSOTO: I created a new model that has your csv as a attachment and are related to your current_user
    userListing = UserListing.find_by(user:current_user)

    if (userListing.nil?)
      userListing = UserListing.create(file: tmp, user: current_user)
    else
      userListing.file = tmp
    end

    userListing.ready!

    #FSOTO: Now userListng.file.url has a valid file on S3, that can be access from your job.
    Listing.import(userListing.file.url , params[:user_id])
    redirect_to seller_url
  end

  def update
    @listing.slug = nil
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end

    ActionController::Base.new.expire_fragment("homepage_p#{params[:page]}_s_#{params[:sort]}", options = nil)

  end

  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to seller_url, notice: 'Listing was successfully deleted.' }
      format.json { head :no_content }
  end

   ActionController::Base.new.expire_fragment("homepage_p#{params[:page]}_s_#{params[:sort]}", options = nil)

  end

  def delete_all
    Listing.where(user: current_user).delete_all
    flash[:notice] = "You have deleted all your listings."
    redirect_to seller_path

    ActionController::Base.new.expire_fragment("homepage_p#{params[:page]}_s_#{params[:sort]}", options = nil)

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:name, :made_to_order, :designer_or_brand, :description, :price, :saleprice, :inventory, :category,
                                      :sku, :image, :image2, :image3, :image4, :featured, :delete_image2, :delete_image3, :delete_image4)
    end

    def check_user
      if current_user.id != @listing.user_id && current_user.name != "admin admin"
        redirect_to root_url, alert: "Sorry, this listing belongs to someone else"
      end
    end

end


   