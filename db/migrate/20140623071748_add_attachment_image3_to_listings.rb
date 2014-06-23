class AddAttachmentImage3ToListings < ActiveRecord::Migration
  def self.up
    change_table :listings do |t|
      t.attachment :image3
    end
  end

  def self.down
    drop_attached_file :listings, :image3
  end
end
