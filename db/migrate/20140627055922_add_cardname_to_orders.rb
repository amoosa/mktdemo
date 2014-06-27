class AddCardnameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cardname, :string
  end
end
