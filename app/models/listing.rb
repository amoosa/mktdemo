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



	validates :name, :description, :price, :inventory, :category, presence: true
	validates :price, :inventory, numericality: {greater_than: 0}

	belongs_to :user
	has_many :orders
end
