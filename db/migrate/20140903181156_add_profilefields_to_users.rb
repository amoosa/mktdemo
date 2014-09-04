class AddProfilefieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profilestory, :text
  end
end
