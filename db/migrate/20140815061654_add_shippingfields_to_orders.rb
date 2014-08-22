class AddShippingfieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tracking, :string, :default => "Not shipped yet"
    add_column :orders, :carrier, :string, :default => "Not shipped yet"
  end
end
