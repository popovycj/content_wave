class ScheduleTime < ApplicationRecord
  extend EnumField::EnumeratedAttribute

  belongs_to :template

  validates :day_id, :time_range_id, presence: true
  validates :day_id, uniqueness: { scope: [ :template_id, :time_range_id ] }

  enumerated_attribute :day
  enumerated_attribute :time_range

  scope :today, -> { where(day_id: Time.now.wday) }
end
