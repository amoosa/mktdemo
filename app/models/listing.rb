class Listing < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, :use => :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

	searchkick

	if Rails.env.development?
		has_attached_file :image, 
						  :styles => { :medium => "250x235", :thumb => "100x100" },
						  :default_url => "",
						  :convert_options => {:medium => '-background white -gravity center -extent 250x235',
						                       :thumb => '-background white -gravity center -extent 100x100' }
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image2, 
						  :styles => { :thumb => "100x100" },
						  :default_url => ""
		validates_attachment_content_type :image2, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image3, 
						  :styles => { :thumb => "100x100" },
						  :default_url => ""
		validates_attachment_content_type :image3, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image4, 
						  :styles => { :thumb => "100x100" },
						  :default_url => ""
		validates_attachment_content_type :image4, :content_type => /\Aimage\/.*\Z/
	else
		has_attached_file :image, 
						  :styles => { :medium => "250x235", :thumb => "100x100" }, 
						  :default_url => "",
						  :convert_options => {:medium => '-background white -gravity center -extent 250x235',
						                       :thumb => '-background white -gravity center -extent 100x100' }
					      #:storage => :dropbox,
	    				  #:dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  #:path => ":style/:id_:filename"
	    	              # :dropbox_options => {...}
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image2, 
						  :styles => { :thumb => "100x100" }, 
						  :default_url => ""					     
						  #:storage => :dropbox,
	    				  # :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  # :path => ":style/:id_:filename"
	    	              # :dropbox_options => {...}
		validates_attachment_content_type :image2, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image3, 
						  :styles => { :thumb => "100x100" }, 
						  :default_url => ""
					      #:storage => :dropbox,
	    				  # :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  # :path => ":style/:id_:filename"
	    	              # :dropbox_options => {...}
		validates_attachment_content_type :image3, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image4, 
						  :styles => { :thumb => "100x100" }, 
						  :default_url => ""
					      #:storage => :dropbox,
	    				  # :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  # :path => ":style/:id_:filename"
	    	              # :dropbox_options => {...}
		validates_attachment_content_type :image4, :content_type => /\Aimage\/.*\Z/
	end

	def self.ownsearch(query)
	  where("description like ? or name like ?", "%#{query}%", "%#{query}%")
    end

  # Those are two &lt; symbols (the blog is screwing them up)
  require 'csv'
  require 'open-uri'

  class << self

	def importcsv(file_path, user_id)
    user_listing = UserListing.find_by(:user_id => user_id)
    user_listing.started!
    begin
    open(file_path) do |f|
		    CSV.parse(f.read , headers: true, skip_blanks: true) do |row|

          listing_hash = {:name => row['Product_title'], 
          	              :description => row['Description'],
          				  :sku => row['Product_ID'],
  						  :price => row['Price'].to_i,
  						  :category => row['Category'].titleize, :inventory => row['Quantity_in_stock'].to_i,
  						  :image => URI.parse(row['Image']),
  						  :user_id => user_id}.tap do |list_hash|
  						  	list_hash[:designer_or_brand] = row['Designer_or_Brand'] if row['Designer_or_Brand'] 
  						  	list_hash[:saleprice] = row['SalePrice'].to_i if row['SalePrice'] 
						    list_hash[:image2] = URI.parse(row['Image2']) if row['Image2'] 
						    list_hash[:image3] = URI.parse(row['Image3']) if row['Image3'] 
						    list_hash[:image4] = URI.parse(row['Image4']) if row['Image4'] 
  								end
 
          listing = Listing.where(sku: listing_hash[:sku], user_id: listing_hash[:user_id]) 

          if listing.count == 1 
            listing.first.update_attributes(listing_hash)
          else
            Listing.create!(listing_hash)
          end 

      end
    end
    user_listing.processed!
    rescue
      user_listing.failed!
    end

	end 

    handle_asynchronously :importcsv

  end

  # My importer as a class method
  def self.import(file, user_id)
    Listing.importcsv(file, user_id)
  end

    # csv export code from railscasts
	def self.to_csv(listings)
	  wanted_columns = [:sku, :name, :designer_or_brand, :description, :price, :saleprice, :inventory, :category]
	  CSV.generate do |csv|
	    csv << ['Product_ID', 'Product_title', 'Designer_or_Brand', 'Description', 'Price', 'SalePrice', 
	    	'Quantity_in_stock', 'Category'] + [:Image, :Image2, :Image3, :Image4] + ['url']
	    listings.each do |listing|
	      attrs = listing.attributes.with_indifferent_access.values_at(*wanted_columns)
	      attrs.push(listing.image.url, listing.image2.try(:url), listing.image3.try(:url), listing.image4.try(:url),
	      	Rails.application.routes.url_helpers.listing_url(listing.id, :host => 'www.outfitadditions.com'))
	      csv << attrs
	    end
	  end
    end

	def self.not_expired
        where('updated_at >= ? and user_id = ? and inventory > ?', Date.current - 1.day, 24, 0)
    end

	def expired?
	 self.updated_at <= (Date.current - 1.day) and self.user.name != "Outfit Additions"
	end

	def saleprice_lower_than_price
	  if (saleprice != nil && saleprice > (price - (price * 0.05)))
	    errors.add(:saleprice, "should be at least 5% less than the regular price")
	  end
	end


	validates :name, :description, :price, :inventory, :category, :sku, presence: true
	validates :name, length: { maximum: 56 }
	validates :designer_or_brand, length: { maximum: 35 }, :allow_blank => true
	validates :description, length: { maximum: 1800 }
	validates :price, numericality: {greater_than: 0}
	validates :inventory, numericality: {greater_than_or_equal_to: 1}
	#validates :saleprice, numericality: {greater_than: 0}, :allow_blank => true
	validate :saleprice_lower_than_price
	validates_attachment_presence :image
	validates_with AttachmentSizeValidator, :attributes => :image, :less_than => 2.megabytes
	validates_with AttachmentSizeValidator, :attributes => :image2, :less_than => 2.megabytes
	validates_with AttachmentSizeValidator, :attributes => :image3, :less_than => 2.megabytes
	validates_with AttachmentSizeValidator, :attributes => :image4, :less_than => 2.megabytes

	belongs_to :user
	has_many :orders

 
end



