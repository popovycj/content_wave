namespace :content_generator do
  desc "Generate daily content"
  task generate: :environment do
    DailyContentGeneratorWorker.perform_async
  end
end
