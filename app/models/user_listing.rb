class UserListing < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file
end
