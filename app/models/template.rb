class Template < ApplicationRecord
  belongs_to :content_datum

  has_one_attached :file
  has_many_attached :backgrounds

  validates :file, attached: true

  before_validation :attach_file_from_views, unless: :file_attachment

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "data", "id", "content_datum_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["backgrounds_attachments", "backgrounds_blobs", "content_datum", "file_attachment", "file_blob",]
  end

  private

  def attach_file_from_views
    content_type  = content_datum.content_type.title.parameterize(separator: '_')
    project_title = content_datum.profile.project.title.parameterize(separator: '_')

    file_path = Rails.root.join(
      "app", "views", "templates", "#{project_title}", "#{content_type.pluralize}", "#{title}", "index.html.erb"
    )

    return false unless File.exist?(file_path)

    file.attach(io: File.open(file_path), filename: "index.html.erb", content_type: "text/html")
  end
end
