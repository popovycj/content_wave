Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  namespace :admin do
    get 'get_content_types', to: 'admin#get_content_types'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
