class PendingContent < ApplicationRecord
  belongs_to :content_datum
  has_one_attached :file

  validates :state, presence: true
  validates :file, attached: true

  before_validation :generate_file_on_create, on: :create

  state_machine :state, initial: :pending do
    event :upload do
      transition any => :uploaded
    end

    event :generate do
      transition pending: :generated
    end

    before_transition pending: :generated, do: :generate_file_content
    before_transition to: :uploaded, do: :upload_content
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[chat_id content_datum_id created_at file id state updated_at]
  end

  private

  def generate_file_on_create
    generate! unless file.attached?
  end

  def generate_file_content
    content_generator = Factories::ContentGeneratorServiceFactory.build(self)
    file_binary = content_generator.call
    attach_file(file_binary)
  end

  def attach_file(file_binary)
    self.file.attach(
      io: StringIO.new(file_binary),
      filename: 'video.mp4', # TODO: make it work with other content types
      content_type: 'video/mp4' # TODO: make it work with other content types
    )
    save!
  end

  def upload_content
    uploader = Factories::ContentUploaderServiceFactory.build(self)
    uploader.call
  end
end
