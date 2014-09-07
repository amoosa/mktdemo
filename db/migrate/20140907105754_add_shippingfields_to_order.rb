class AddShippingfieldsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shipcompany, :string
    add_column :orders, :shipaddress2, :string
    add_column :orders, :address2, :string
  end
end
