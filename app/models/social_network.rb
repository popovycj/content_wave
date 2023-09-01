class SocialNetwork < ApplicationRecord
  has_many :profiles
  has_and_belongs_to_many :content_types

  validates :title, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["profiles", "content_types"]
  end
end
