class AddAttachmentProfileimageToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :profileimage
    end
  end

  def self.down
    drop_attached_file :users, :profileimage
  end
end
