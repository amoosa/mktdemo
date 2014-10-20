class AddSaleToListings < ActiveRecord::Migration
  def change
    add_column :listings, :saleprice, :integer
    add_column :listings, :designer_or_brand, :string
  end
end
