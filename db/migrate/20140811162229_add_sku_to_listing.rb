class AddSkuToListing < ActiveRecord::Migration
  def change
    add_column :listings, :sku, :string
  end
end
