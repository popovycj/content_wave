class Template < ApplicationRecord
  belongs_to :project
  belongs_to :content_type

  has_one_attached :file
  has_many_attached :backgrounds

  validates :file, attached: true, content_type: ['text/html', 'application/x-erb', 'text/slim']
  validates :backgrounds, content_type: ['video/mp4']

  validates :project_id, :content_type_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["content_type_id", "created_at", "data", "id", "project_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["backgrounds_attachments", "backgrounds_blobs", "content_type", "file_attachment", "file_blob", "project"]
  end
end
