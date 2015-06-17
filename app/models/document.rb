class Document < ActiveRecord::Base
  mount_uploader :file, FileUploader
  validates :name, :file, presence: true
end
