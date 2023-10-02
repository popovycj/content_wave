class CreateScheduleTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_times do |t|
      t.references :template, null: false, foreign_key: true
      t.bigint :day_id, null: false
      t.bigint :time_range_id, null: false

      t.timestamps
    end
  end
end
