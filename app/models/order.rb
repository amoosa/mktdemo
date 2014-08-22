class Order < ActiveRecord::Base
	validates :cardname, :address, :city, :state, :zip, 
	          :shipname, :shipaddress, :shipcity, :shipstate, :shipzip, 
	          :tracking, :carrier, presence: true
	validates :zip, :shipzip, length: { is: 5 }

	belongs_to :listing
	belongs_to :buyer, class_name: "User"
	belongs_to :seller, class_name: "User"

    after_create :decrement_stock

	def decrement_stock
	    self.listing.update_attribute("inventory", (listing.inventory - 1))
	end

end
