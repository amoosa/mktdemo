class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   validates :name, presence: true, uniqueness: true

   has_many :listings, dependent: :destroy
   has_many :orders, class_name: "Order", foreign_key: "seller_id"
   has_many :purchases, class_name: "Order", foreign_key: "buyer_id"


	if Rails.env.development?
		has_attached_file :profileimage, 
						  :styles => { :profile => "200x200", :p_thumb => "100x100>" },
						  :default_url => ""
        validates_attachment_content_type :profileimage, :content_type => /\Aimage\/.*\Z/
	else
		has_attached_file :profileimage, 
						  :styles => { :profile => "200x200", :p_thumb => "100x100>" }, 
						  :default_url => "",
					      :storage => :dropbox,
	    				  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	    				  :path => ":style/:id_:filename" 
	    validates_attachment_content_type :profileimage, :content_type => /\Aimage\/.*\Z/
	end

end
