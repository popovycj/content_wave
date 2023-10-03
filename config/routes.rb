require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  ActiveAdmin.routes(self)

  namespace :admin do
    get 'get_content_types', to: 'admin#get_content_types'
  end
end
