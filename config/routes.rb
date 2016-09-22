# frozen_string_literal: true
Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # General Routes
  resources :offers
  resources :organizations
  resources :categories do
    collection do
      get :sort
      get :mindmap
    end
  end
  resources :offer_translations, only: [:index, :edit, :update]
  resources :organization_translations, only: [:index, :edit, :update]
  resources :productivity_goals
  resources :users, only: [:index, :edit, :update]
  resources :user_teams
  get 'time_allocations(/:year/:week_number)', controller: :time_allocations,
                                               action: :index

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

  # Stats
  get '/statistics(/:subpage)' => 'statistics#index', as: :statistics
  # get '/statistics/:topic(/:user_id)' => 'statistics#show', as: :statistic

  # non-REST paths
  # ...

  # API
  namespace :api, defaults: {format: :json}  do
    namespace :v1 do
      resources :categories do
        collection do
          put 'sort'
        end
      end
      resources :offers, only: [:show]
      resources :locations, only: [:index]
      resources :organizations, only: [:show, :index]
      get '/statistics' => 'statistics#index'
      resources :users, only: [:index, :update]
      resources :offer_translations, only: [:index, :show, :update]
      resources :organization_translations, only: [:index, :show, :update]
      resources :productivity_goals, except: [:destroy]
      resources :time_allocations, only: [:create, :update]
      post 'time_allocations/:year/:week_number',  controller: :time_allocations,
                                                   action: :report_actual
      # get '/statistics/:topic/:user_id(/:start/:end)' => 'statistics#index'
    end
  end

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
  require 'sidekiq-cron'
  require 'sidekiq/cron/web'
  constraint = lambda do |request|
    request.env['warden'].authenticate?
  end
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end
end
