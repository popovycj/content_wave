class Project < ApplicationRecord
  has_many :profiles
  has_many :templates

  validates :title, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["profiles", "templates"]
  end
end
