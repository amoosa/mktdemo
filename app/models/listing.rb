class Listing < ActiveRecord::Base
	if rails.env.development?
		has_attached_file :image, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	else
		has_attached_file :image, 
						  :styles => { :medium => "200x>", :thumb => "100x100>" }, 
						  :default_url => "missing.jpg",
					      :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename"
	    	             # :dropbox_options => {...}
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
		#validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png) 
		#validates_attachment_content_type :image, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)/
		#do_not_validate_attachment_file_type :image
	end
end
