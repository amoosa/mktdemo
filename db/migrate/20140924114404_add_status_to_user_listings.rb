class AddStatusToUserListings < ActiveRecord::Migration
  def change
    add_column :user_listings, :process_status, :integer, :default => 0
  end
end
