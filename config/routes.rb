Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # General Routes
  resources :offers
  resources :organizations, only: [:show]

  # unscoped RESTful resources (only POST and non-HTML GET)
  get 'categories/:offer_name', controller: :categories, action: :index

  # non-REST paths
  # ...

  # Devise
  devise_for :users, class_name: 'User'
  devise_scope :user do
    authenticated do
      root to: 'dashboards#main'
    end

    unauthenticated do
      root to: 'devise/sessions#new', as: 'unauthenticated_root'
    end
  end

  # Sidekiq interface
  require 'sidekiq/web'
  require 'sidetiq/web'
  constraint = lambda do |request|
    request.env['warden'].authenticate?
  end
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end
end
