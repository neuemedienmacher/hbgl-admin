Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # General Routes
  resources :offers
  resources :organizations
  resources :categories
  resources :next_steps_offers, only: [:index]

  # Export
  get 'exports/:object_name/new', controller: :exports, action: :new,
                                  as: :new_export
  post 'exports/:object_name/', controller: :exports, action: :create,
                                as: :exports

  get 'categories/:offer_name', controller: :categories, action: :index
  get 'next_steps_offers/:offer_id', controller: :next_steps_offers,
                                     action: :index
  put 'next_steps_offers/:id', controller: :next_steps_offers, action: :update

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
