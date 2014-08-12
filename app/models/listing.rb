class Listing < ActiveRecord::Base

	if Rails.env.development?
		has_attached_file :image, 
						  :styles => { :medium => "200x", :thumb => "100x100>" },
						 						  :default_url => "missing.jpg"
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image2, 
						  :styles => { :medium => "200x", :thumb => "100x100>" },
						  :default_url => "missing.jpg"
		validates_attachment_content_type :image2, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image3, 
						  :styles => { :medium => "200x", :thumb => "100x100>" },
						  :default_url => "missing.jpg"
		validates_attachment_content_type :image3, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image4, 
						  :styles => { :medium => "200x", :thumb => "100x100>" },
						  :default_url => "missing.jpg"
		validates_attachment_content_type :image4, :content_type => /\Aimage\/.*\Z/
	else
		has_attached_file :image, 
						  :styles => { :medium => "200x", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",
					      :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image2, 
						  :styles => { :medium => "200x", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",					     
						  :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image2, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image3, 
						  :styles => { :medium => "200x", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",
					      :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image3, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image4, 
						  :styles => { :medium => "200x", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",
					      :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image4, :content_type => /\Aimage\/.*\Z/
	end

	def self.search(query)
	  where("description like ? or name like ?", "%#{query}%", "%#{query}%")
	end

  require 'csv'
  require 'open-uri'

	def self.import(file, userid)
		CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|

          listing_hash = {:name => row['Product title'], :description => row['Description'], :sku => row['Product_id'],
  						  :price => row['Price'], :category => row['Category'], :inventory => row['Quantity in stock'],
  						  :userid => userid}.tap do |list_hash|
						    list_hash[:image] = URI.parse(row['Image']) if row['Image']
						    list_hash[:image2] = URI.parse(row['Image2']) if row['Image2'] 
						    list_hash[:image3] = URI.parse(row['Image3']) if row['Image3'] 
						    list_hash[:image4] = URI.parse(row['Image4']) if row['Image4'] 
  								end
 
          listing = Listing.where(sku: listing_hash[:sku], userid: listing_hash[:userid]) 

          if listing.count == 1 #this doesn't update. need to fix.
            listing.first.update_attributes(listing_hash)
          else
            Listing.create!(listing_hash)
          end # end if !product.nil?

		 
		end # end CSV.foreach
	end # end self.import(file)

	validates :name, :description, :price, :inventory, :category, :sku, presence: true
	validates :price, :inventory, numericality: {greater_than: 0}
	validates_attachment_presence :image

	belongs_to :user
	has_many :orders

 
end
