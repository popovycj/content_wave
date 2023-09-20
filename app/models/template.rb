class Template < ApplicationRecord
  belongs_to :profile
  belongs_to :content_type

  has_many :pending_contents, dependent: :destroy

  has_one_attached :file
  has_many_attached :backgrounds

  validates :file, attached: true
  validates :profile_id, :content_type_id, presence: true, uniqueness: { scope: [:profile_id, :content_type_id] }

  before_validation :attach_file_from_views, unless: :file_attachment

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "data", "id", "profile_id", "title", "content_type_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["backgrounds_attachments", "backgrounds_blobs", "profile", "content_type", "file_attachment", "file_blob",]
  end

  private

  def attach_file_from_views
    content_type  = content_type.title.underscore.parameterize(separator: '_')
    project_title = profile.project.title.underscore.parameterize(separator: '_')

    file_path = Rails.root.join(
      "app", "views", "templates", "#{project_title}", "#{content_type.pluralize}", "#{title}", "index.html.erb"
    )

    return false unless File.exist?(file_path)

    file.attach(io: File.open(file_path), filename: "index.html.erb", content_type: "text/html")
  end
end
