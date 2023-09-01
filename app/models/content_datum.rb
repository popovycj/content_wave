class ContentDatum < ApplicationRecord
  belongs_to :profile
  belongs_to :content_type

  validates :profile_id, :content_type_id, presence: true, uniqueness: { scope: [:profile_id, :content_type_id] }
  validates :description, length: { maximum: 255 }
  validates :tags, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    ["content_type_id", "created_at", "description", "id", "profile_id", "prompt", "tags", "updated_at"]
  end
end
