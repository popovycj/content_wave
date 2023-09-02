class ContentDatum < ApplicationRecord
  belongs_to :profile
  belongs_to :content_type

  has_one :template

  accepts_nested_attributes_for :template

  validates :profile_id, :content_type_id, presence: true, uniqueness: { scope: [:profile_id, :content_type_id] }
  validates :description, length: { maximum: 255 }
  validates :tags, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    ["content_type_id", "created_at", "description", "id", "profile_id", "prompt", "tags", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["content_type", "profile", "template"]
  end

  def to_s
    "#{profile.title} - #{content_type.title}"
  end

  alias_method :title, :to_s
end
