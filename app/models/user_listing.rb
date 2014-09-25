class UserListing < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file
  validates_attachment_content_type :file, :content_type =>  %w('text/plain','text/csv','application/vnd.ms-excel')
  #validates_attachment_content_type :file, :content_type => %w(application/zip application/msword application/vnd.ms-office application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)


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
  end

  def is_failed?
    self.process_status == 3
  end
end
