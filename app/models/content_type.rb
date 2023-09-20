class ContentType < ApplicationRecord
  has_many :templates
  has_and_belongs_to_many :social_networks

  validates :title, presence: true, length: { maximum: 255 }
  validates :file_content_type, presence: true

  enum file_content_type: {
    video_mp4: 'video/mp4',
    image_jpeg: 'image/jpeg'
  }

  def mime_type
    self.class.file_content_types[file_content_type]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "title", "file_content_type", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["content_data", "templates", "social_networks"]
  end
end
