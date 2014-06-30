class Order < ActiveRecord::Base
	validates :cardname, :address, :city, :state, :zip, presence: true

	belongs_to :listing
	belongs_to :buyer, class_name: "User"
	belongs_to :seller, class_name: "User"

    after_create :decrement_stock

	def decrement_stock
	    self.listing.update_attribute("inventory", (listing.inventory - 1))
	end

end
