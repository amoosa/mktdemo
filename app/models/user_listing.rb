class UserListing < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file, :content_type => 'text/csv'
end
