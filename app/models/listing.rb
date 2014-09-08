class Listing < ActiveRecord::Base

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
						                       :thumb => '-background white -gravity center -extent 100x100' },
						  :storage => :s3, 
                          :s3_credentials => "#{Rails.root}/config/application.yml"
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

	def self.search(query)
	  where("description like ? or name like ?", "%#{query}%", "%#{query}%")
	end

  require 'csv'
  require 'open-uri'

	def self.import(file, user_id)
		CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|

          listing_hash = {:name => row['Product title'], 
          	              :description => row['Description'],
          				  :sku => row['Product_id'],
  						  :price => row['Price'], :category => row['Category'.downcase.titleize], :inventory => row['Quantity in stock'],
  						  :image => URI.parse(row['Image']),
  						  :user_id => user_id}.tap do |list_hash|
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

		 
		end # end CSV.foreach
	end # end self.import(file)

    # csv export code from railscasts
	def self.to_csv(listings)
	  wanted_columns = [:sku, :name, :description, :price, :inventory, :category]
	  CSV.generate do |csv|
	    csv << ['Product_id', 'Product title', 'Description', 'Price', 'Quantity in stock', 'Category'] + [:Image, :Image2, :Image3, :Image4]
	    listings.each do |listing|
	      attrs = listing.attributes.with_indifferent_access.values_at(*wanted_columns)
	      attrs.push(listing.image.url, listing.image2.try(:url), listing.image3.try(:url), listing.image4.try(:url)) 
	      # if image is not always present, use `listing.image.try(:url)`
	      csv << attrs
	    end
	  end
    end

	def self.not_expired
        where('updated_at >= ?', Date.current - 30.day)
    end

	def expired?
	 self.updated_at <= (Date.current - 30.day)
	end

	validates :name, :description, :price, :inventory, :category, :sku, presence: true
	validates :price, :inventory, numericality: {greater_than: 0}
	validates_attachment_presence :image

	belongs_to :user
	has_many :orders

 
end
