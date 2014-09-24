class AddAttachmentFileToUserListings < ActiveRecord::Migration
  def self.up
    change_table :user_listings do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :user_listings, :file
  end
end
