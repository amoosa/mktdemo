class ChangeUseridname < ActiveRecord::Migration
  def change
  	rename_column :listings, :userid, :user_id
  end
end
