class AddSkuToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :listingsku, :string
  end
end
