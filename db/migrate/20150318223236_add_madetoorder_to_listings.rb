class AddMadetoorderToListings < ActiveRecord::Migration
  def change
    add_column :listings, :made_to_order, :string
  end
end
