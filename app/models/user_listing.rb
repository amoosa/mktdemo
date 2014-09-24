class UserListing < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file
  validates_attachment :file, content_type: { content_type: ['text/plain','text/csv'] }


  def started!
    self.process_status = 1
    self.save!
  end

  def processed!
    self.process_status = 2
    self.save!
  end

  def ready!
    self.process_status = 0
    self.save!
  end

  def failed!
    self.process_status = 3
    self.save!
  end

  def listed!
    self.process_status = 4
    self.save!
  end

  def is_processed?
    self.process_status == 2
    self.save!
  end

  def is_failed?
    self.process_status == 3
    self.save!
  end
end
