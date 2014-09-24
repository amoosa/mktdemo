class CreateUserListings < ActiveRecord::Migration
  def change
    create_table :user_listings do |t|
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
