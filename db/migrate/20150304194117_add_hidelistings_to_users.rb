class AddHidelistingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hidelistings, :boolean, :default => false
  end
end
