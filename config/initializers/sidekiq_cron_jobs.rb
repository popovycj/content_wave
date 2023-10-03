job_name = "DailyContentGeneratorWorker - every day at 4am"
Sidekiq::Cron::Job.create(
  name: job_name,
  cron: "0 4 * * *",
  klass: 'DailyContentGeneratorWorker',
  queue: 'default'
) unless Sidekiq::Cron::Job.find(job_name)
