# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.7'

gem 'nokogiri', '1.6.7.2' # 1.6.8 doesnt install on some pcs. Remove when fixed

###########
# General #
###########

gem 'rails', '5.1.6.1'
gem 'bundler', '>= 1.8.4'

gem 'clarat_base', :git => 'https://github.com/neuemedienmacher/hbg-base.git', :ref => '55e9aa0ecb558592d72bd23575f4d7f4e2d2fe33'
#gem 'clarat_base', path: "../hbg-base"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 4.1.12'
gem 'rails-observers', '= 0.1.5' # observers got extracted since rails 4

# Translations
gem 'rails-i18n'
gem 'i18n-js'
gem 'easy_translate'

gem 'dynamic_sitemaps', github: 'efqdalton/dynamic_sitemaps',
                        branch: 'adds-custom-storages'

# Platforms Ruby
platforms :ruby do
  gem 'sqlite3', group: :test # sqlite3 for inmemory testing db
  gem 'therubyracer' # js runtime
  gem 'pg', group: %i[production staging development] # postgres
end

# Templating with slim
gem 'slim-rails'

#######################
# CLARADMIN SPECIFICS #
#######################

gem 'rails_admin_clone' # must come before rails_admin to work correctly
gem 'rails_admin'
# gem 'rails_admin_nested_set'
gem 'rails_admin_nestable'
gem 'cancan' # role based auth for rails_admin
0
gem 'devise'
gem 'pundit'

gem 'trailblazer', '2.0.7'
gem 'trailblazer-loader', '0.1.2'
gem 'trailblazer-rails', '1.0.4'
gem 'trailblazer-endpoint', :git => 'https://github.com/trailblazer/trailblazer-endpoint.git', :ref => '9ec75c0'
gem 'trailblazer-cells', '0.0.3'
gem 'trailblazer-operation', '0.0.13'
gem 'cells'
gem 'cells-slim'
gem 'cells-rails'
gem 'reform', '2.2.4'
gem 'reform-rails', '0.1.7'
gem 'roar', github: 'apotonick/roar', branch: 'master'
gem 'roar-jsonapi', :git => 'https://github.com/trailblazer/roar-jsonapi', :tag => 'v0.0.3'
gem 'multi_json'
gem 'will_paginate'
gem 'activesupport', '5.1.6.1'

gem 'simple_form', '3.5.0'
gem 'dry-validation', '0.11.1'
gem 'dry-types', '0.12.2'
gem 'dry-core', '0.4.1'
gem 'dry-logic', '0.4.2'
gem 'dry-equalizer', '0.2.0'
gem 'dry-container', '0.6.0'
gem 'dry-configurable', '0.7.0'
gem 'dry-matcher', '0.6.0'

# Internal Search Implementation
gem 'pg_search', '2.1.1'

# for sidekiq web interface
gem 'sinatra', '>= 1.3.0'

# Schedulable jobs for sidekiq
gem 'sidekiq-cron', '~> 0.4.0'
gem 'rufus-scheduler', '3.2.2'

gem 'httparty'

# converting between unicode and ascii urls
gem 'simpleidn'
# Faraday for http requests and middleware for redirects
gem 'faraday'
gem 'faraday_middleware'

# ActiveRecord Extension
gem 'rails_or'

gem 'sprockets', '3.7.2'

########################
# For Heroku & Add-Ons #
########################

gem 'rack-cache'
gem 'memcachier'
gem 'dalli' # Memcached Client
gem 'kgio'

group :production, :staging do
  gem 'rails_12factor' # heroku recommends this
  gem 'heroku-deflater' # gzip compression
end

# Logging
gem 'lograge' # opinionated slimmer logs for production

# Puma server
gem 'puma'

#############################
# Assets: CSS /  JavaScript #
#############################

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.0'

gem 'hogan_assets' # TODO: deprecated!
group :assets do # TODO: deprecated!
  gem 'haml' # TODO: deprecated!
end # TODO: deprecated!

source 'https://rails-assets.org' do
  gem 'rails-assets-lodash'
  gem 'rails-assets-jquery', '2.2.4'
  gem 'rails-assets-qtip2', '2.2.1'
  gem 'rails-assets-shariff', '2.0.4'
  gem 'rails-assets-algoliasearch', '3.24.5'
  gem 'rails-assets-bootstrap', '3.3.7'
  gem 'rails-assets-font-awesome', '4.7.0'
  gem 'rails-assets-d3', '4.11.0'
  gem 'rails-assets-nestable2', '1.6.0'
end

gem 'react_on_rails', '6.10.1'

#####################
# Dev/Test Specific #
#####################

group :development do
  # startup
  gem 'spring' # faster rails start

  # errors
  gem 'better_errors'
  gem 'binding_of_caller'

  # debugging in chrome with RailsPanel
  gem 'meta_request'

  # requires graphviz to generate
  # entity relationship diagrams
  gem 'rails-erd', require: false

  gem 'foreman'
end

group :test do
  gem 'memory_test_fix' # Sqlite inmemory fix
  gem 'rake'
  gem 'database_cleaner'
  gem 'fakeredis'
  gem 'fakeweb', '~> 1.3'
  gem 'webmock'
  gem 'pry-rescue'

  # testing emails
  gem 'email_spec'

  # js tests
  gem 'capybara-selenium'

  # ActionCable tests - remove once their PRs are merged by rails
  gem 'action-cable-testing'
end

group :development, :test do
  # debugging
  gem 'pry-rails' # pry is awsome
  gem 'hirb' # hirb makes pry output even more awesome
  gem 'pry-byebug' # kickass debugging
  gem 'pry-stack_explorer' # step through stack
  gem 'pry-doc' # read ruby docs in console

  # test suite
  gem 'rails-controller-testing'
  gem 'minitest', '5.10.1' # Testing using Minitest
  gem 'minitest-matchers'
  gem 'minitest-line'
  gem 'launchy' # save_and_open_page
  gem 'shoulda'
  gem 'minitest-rails-capybara'
  gem 'mocha'

  # test suite additions
  gem 'rails_best_practices'
  gem 'brakeman' # security test: execute with 'brakeman'
  gem 'rubocop', '0.49.1' # style enforcement
  gem 'colorize' # output coloring

  # Code Coverage
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'codeclimate-test-reporter', require: false

  # dev help
  gem 'thin' # Replace Webrick
  gem 'bullet' # Notify about n+1 queries
  gem 'letter_opener' # emails in browser
  gem 'timecop' # time travel!
  gem 'dotenv-rails' # handle environment variables
end

group :development, :test, :staging do
  gem 'factory_girl_rails'
  gem 'ffaker'
end
