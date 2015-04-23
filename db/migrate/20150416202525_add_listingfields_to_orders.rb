class AddListingfieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :listingname, :string
    add_column :orders, :listingimage, :string
  end
end
