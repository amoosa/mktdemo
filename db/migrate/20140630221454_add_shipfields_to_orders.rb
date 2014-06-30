class AddShipfieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipname, :string
    add_column :orders, :shipaddress, :string
    add_column :orders, :shipcity, :string
    add_column :orders, :shipstate, :string
    add_column :orders, :shipzip, :string
  end
end
