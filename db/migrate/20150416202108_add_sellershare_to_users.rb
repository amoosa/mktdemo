class AddSellershareToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sellershare, :integer, :default => "80"
  end
end
