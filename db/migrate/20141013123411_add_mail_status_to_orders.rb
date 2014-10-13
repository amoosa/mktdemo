class AddMailStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :mail_status, :boolean, :default => false
  end
end
