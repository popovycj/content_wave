class DailyContentGeneratorWorker
  include Sidekiq::Worker

  def perform
    Template.with_today_schedule_times.find_each do |template|
      template.schedule_times.each do |schedule_time|
        time_to_upload = schedule_time.time_range.random_time
        content = template.pending_contents.create!(time_to_upload: time_to_upload)

        ContentGeneratorWorker.perform_async(content.id)
      end
    end
  end
end
