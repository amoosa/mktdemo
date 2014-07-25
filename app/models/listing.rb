class Listing < ActiveRecord::Base

	if Rails.env.development?
		has_attached_file :image, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" },
						 						  :default_url => "missing.jpg"
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image2, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" },
						  :default_url => "missing.jpg"
		validates_attachment_content_type :image2, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image3, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" },
						  :default_url => "missing.jpg"
		validates_attachment_content_type :image3, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image4, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" },
						  :default_url => "missing.jpg"
		validates_attachment_content_type :image4, :content_type => /\Aimage\/.*\Z/
	else
		has_attached_file :image, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",
					      :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image2, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",					     
						  :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image2, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image3, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",
					      :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image3, :content_type => /\Aimage\/.*\Z/
		has_attached_file :image4, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",
					      :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image4, :content_type => /\Aimage\/.*\Z/
	end

  require 'csv'
  require 'open-uri'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|

      #listing_hash = row.to_hash
      listing_hash = {:name => row['Name'], :description => row['Description'], :price => row['Price'],
      					:inventory => row['Inventory'], :category => row['Category'], 
      					:image => URI.parse(row['Image']), :image2 => row['Image2'],
      					:image3 => row['Image3'],:image4 => row['Image4'] } 
      listing = Listing.where(id: listing_hash["id"])

      if listing.count == 1
        listing.first.update_attributes(listing_hash)
      else
        Listing.create!(listing_hash)
      end # end if !product.nil?
    end # end CSV.foreach
  end # end self.import(file)

	validates :name, :description, :price, :inventory, :category, presence: true
	validates :price, :inventory, numericality: {greater_than: 0}

	belongs_to :user
	has_many :orders

 
end
