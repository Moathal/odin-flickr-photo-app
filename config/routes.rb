Rails.application.routes.draw do

  require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'

  resources :photographers, only: [:index, :create] do
    resources :photographs, only: [:index]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "photographers#index"
end
