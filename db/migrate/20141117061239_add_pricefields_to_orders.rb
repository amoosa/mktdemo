class AddPricefieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :price_sold, :decimal, :precision => 8, :scale => 2
    add_column :orders, :seller_payment, :decimal, :precision => 8, :scale => 2
  end
end
