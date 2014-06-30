class AddInventoryToListing < ActiveRecord::Migration
  def change
    add_column :listings, :inventory, :integer
  end
end
