class Template < ApplicationRecord
  belongs_to :profile
  belongs_to :content_type

  has_many :pending_contents, dependent: :destroy
  has_many :schedule_times, dependent: :destroy

  accepts_nested_attributes_for :schedule_times, allow_destroy: true

  validates :profile_id, :content_type_id, presence: true

  scope :with_today_schedule_times, -> {
    joins(:schedule_times)
    .merge(ScheduleTime.today)
    .includes(:schedule_times)
  }

  def self.ransackable_attributes(auth_object = nil)
    "created_at data id profile_id title content_type_id updated_at"
  end

  def self.ransackable_associations(auth_object = nil)
    "profile content_type"
  end

  def data_template_path
    template_path("data.json.erb")
  end

  def image_template_path
    template_path("image.html.erb")
  end

  def description_template_path
    template_path("description.html.erb")
  end

  def openai_config_template_path
    template_path("openai_config.json.erb")
  end

  def backgrounds
    []
  end

  private

  def content_type_title
    @content_type_title ||= content_type.title.underscore.parameterize(separator: '_')
  end

  def project_title
    @project_title ||= profile.project.title.underscore.parameterize(separator: '_')
  end

  def generate_template_path(file_name)
    Rails.root.join(
      "app", "views", "templates", project_title, content_type_title.pluralize, title, file_name
    )
  end

  def template_path(file_name)
    file_path = generate_template_path(file_name)
    return unless File.exist?(file_path)

    file_path
  end
end
