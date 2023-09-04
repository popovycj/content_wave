class PendingContent < ApplicationRecord
  # Associations
  belongs_to :content_datum
  has_one_attached :file

  # Validations
  validates :state, presence: true
  validates :file, attached: true

  # State machine
  state_machine :state, initial: :pending do
    event :upload do
      transition pending: :uploaded
    end

    before_transition pending: :uploaded do |content|
      data    = content.content_datum
      profile = data.profile

      tags           = data.tags
      description    = data.description
      content_type   = data.content_type.title
      file_binary    = content.file.download
      auth_data      = profile.auth_data
      social_network = profile.social_network.title

      uploader = "Uploaders::#{social_network.capitalize}#{content_type.capitalize}UploaderService".constantize

      session_id = auth_data['session_id'] # TODO: get rid of this hardcode

      uploader.new(session_id, description, tags, file_binary).call
    end

    # Uncomment this if you want to purge the file after upload
    # after_transition on: :upload do |content|
    #   content.file.purge if content.file.attached?
    # end
  end

  # Ransack searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[chat_id content_datum_id created_at file id state updated_at]
  end
end
