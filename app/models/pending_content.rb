class PendingContent < ApplicationRecord
  belongs_to :content_datum
  has_one_attached :file

  validates :state, presence: true
  validates :file, attached: true

  before_validation :generate_file_on_create, on: :create

  state_machine :state, initial: :created do
    event :upload do
      transition any => :uploaded
    end

    event :generate do
      transition created: :generated
    end

    before_transition created: :generated, do: :generate_file_content
    before_transition to: :uploaded, do: :upload_content
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[chat_id content_datum_id created_at file id state updated_at]
  end

  def file_path
    ActiveStorage::Blob.service.path_for(file.key)
  end

  private

  def generate_file_on_create
    generate! unless file.attached?
  end

  def generate_file_content
    file_binary = ContentGeneratorService.new(content_datum).call

    content_type   = content_datum.content_type
    mime_type      = content_type.mime_type
    file_extension = mime_type.split('/').last
    file.attach(
      io: StringIO.new(file_binary),
      filename: "content.#{file_extension}",
      content_type: mime_type
    )
    save!
  end

  def upload_content
    raise 'File is not attached' unless file.attached?

    ContentUploaderService.new(content_datum, content_datum.profile, file_path).call
  end
end
