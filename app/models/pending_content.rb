class PendingContent < ApplicationRecord
  belongs_to :template
  has_one_attached :file, dependent: :destroy

  validates :state, presence: true

  after_create :schedule_deletion

  state_machine :state, initial: :created do
    event :generate do
      transition created: :generated
    end

    event :regenerate do
      transition generated: :created
    end

    event :schedule do
      transition any => :scheduled
    end

    event :upload do
      transition any => :uploaded
    end

    before_transition created: :generated, do: :generate_content
    before_transition to: :scheduled, do: :schedule_content
    before_transition to: :uploaded, do: :upload_content
    after_transition on: :regenerate, do: :regenerate_content
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[chat_id template_id created_at file id state updated_at]
  end

  def file_path
    ActiveStorage::Blob.service.path_for(file.key)
  end

  private

  def schedule_deletion
    deletion_time = created_at + 1.day
    ContentDestroyerWorker.perform_at(deletion_time, id)
  end

  def generate_content
    file_binary, description = ContentGeneratorService.new(template).call

    update(description: description)
    attach_file(file_binary)
  end

  def attach_file(file_binary)
    content_type   = template.content_type
    mime_type      = content_type.mime_type
    file_extension = mime_type.split('/').last

    file.attach(
      io: StringIO.new(file_binary),
      filename: "content.#{file_extension}",
      content_type: mime_type
    )
    save!
  end

  def schedule_content
    upload_time = next_occurrence_of_time(time_to_upload)
    ContentUploaderWorker.perform_at(upload_time, id)
  end

  def upload_content
    raise 'File is not attached' unless file.attached?

    ContentUploaderService.new(self).call
  end

  def next_occurrence_of_time(time_str)
    now = Time.now
    hour, min = time_str.split(":").map(&:to_i)
    target_time = now.change(hour: hour, min: min)

    target_time > now ? target_time : now + 30.minutes
  end

  def regenerate_content
    file.purge
    generate!
  end
end
