class Template < ApplicationRecord
  belongs_to :content_datum

  has_one_attached :file
  has_many_attached :backgrounds

  validates :file, attached: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "data", "id", "content_datum_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["backgrounds_attachments", "backgrounds_blobs", "content_datum", "file_attachment", "file_blob",]
  end
end
