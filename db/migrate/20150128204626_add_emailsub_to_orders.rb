class AddEmailsubToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :emailsub, :boolean, :default => false
  end
end
