class UserListing < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file
  validates_attachment :file, content_type: { content_type: 'text/plain' }
end
