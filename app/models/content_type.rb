class ContentType < ApplicationRecord
  has_many :templates
  has_many :content_data
  has_and_belongs_to_many :social_networks

  validates :title, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["content_data", "templates", "social_networks"]
  end
end
