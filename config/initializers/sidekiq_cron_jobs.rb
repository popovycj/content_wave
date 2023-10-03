job_name = "DailyContentGeneratorWorker - every 5 minutes"
Sidekiq::Cron::Job.create(
  name: job_name,
  cron: "*/5 * * * *",
  klass: 'DailyContentGeneratorWorker',
  queue: 'default'
) unless Sidekiq::Cron::Job.find(job_name)
