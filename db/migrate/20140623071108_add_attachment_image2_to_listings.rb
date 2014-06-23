class AddAttachmentImage2ToListings < ActiveRecord::Migration
  def self.up
    change_table :listings do |t|
      t.attachment :image2
    end
  end

  def self.down
    drop_attached_file :listings, :image2
  end
end
