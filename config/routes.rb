Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'home#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
