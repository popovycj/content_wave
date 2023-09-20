class Profile < ApplicationRecord
  belongs_to :project
  belongs_to :social_network

  has_many :templates

  validates :project_id, :social_network_id, presence: true, uniqueness: { scope: [:project_id, :social_network_id] }
  validates :auth_data, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["auth_data", "created_at", "id", "project_id", "social_network_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["content_data", "project", "social_network"]
  end

  def to_s
    "#{project.title} - #{social_network.title}"
  end

  alias_method :title, :to_s
end
