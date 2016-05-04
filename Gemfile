source 'https://rubygems.org'
ruby '2.3.0'

###########
# General #
###########

gem 'rails', '~> 4.2'
gem 'bundler', '>= 1.8.4'

gem 'clarat_base', github: 'clarat-org/clarat_base'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 4.1.12'
gem 'rails-observers' # observers got extracted since rails 4

# Translations
gem 'rails-i18n'

gem 'dynamic_sitemaps', github: 'efqdalton/dynamic_sitemaps',
                        branch: 'adds-custom-storages'

# Platforms Ruby
platforms :ruby do
  gem 'sqlite3', group: :test # sqlite3 for inmemory testing db
  gem 'therubyracer' # js runtime
  gem 'pg', group: [:production, :staging, :development] # postgres
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

gem 'devise'

gem 'trailblazer'
# gem 'trailblazer-loader'
gem 'trailblazer-rails'
gem 'cells'
gem 'cells-slim'
gem 'reform'
gem 'reform-rails'
gem 'roar'
gem 'multi_json'

gem 'simple_form'
gem 'dry-validation'

# Internal Search Implementation
gem 'pg_search'

########################
# For Heroku & Add-Ons #
########################

gem 'newrelic_rpm'
gem 'rack-cache'
gem 'memcachier'
gem 'dalli' # Memcached Client
gem 'kgio'

group :production, :staging do
  gem 'rails_12factor' # heroku recommends this
  gem 'heroku-deflater' # gzip compression
end

# email
gem 'gibbon', '~> 1.2.0' # uses MailChimp API 2.0, remove version for 3.0+

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
gem 'coffee-rails', '~> 4.0.0'

gem 'hogan_assets' # TODO: deprecated!
group :assets do # TODO: deprecated!
  gem 'haml' # TODO: deprecated!
end # TODO: deprecated!

source 'https://rails-assets.org' do
  gem 'rails-assets-lodash' # (aka underscore) diverse js methods
  gem 'rails-assets-jquery'
  gem 'rails-assets-qtip2'
  gem 'rails-assets-shariff'
  gem 'rails-assets-algoliasearch' # search client
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-flat-ui'
  gem 'rails-assets-d3'
  gem 'rails-assets-nestable2'
end

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

  # Quiet Assets to disable asset pipeline in log
  gem 'quiet_assets'

  # requires graphviz to generate
  # entity relationship diagrams
  gem 'rails-erd', require: false
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
end

group :development, :test do
  # debugging
  gem 'pry-rails' # pry is awsome
  gem 'hirb' # hirb makes pry output even more awesome
  gem 'pry-byebug' # kickass debugging
  gem 'pry-stack_explorer' # step through stack
  gem 'pry-doc' # read ruby docs in console

  # test suite
  gem 'minitest' # Testing using Minitest
  gem 'minitest-matchers'
  gem 'minitest-line'
  gem 'launchy' # save_and_open_page
  gem 'shoulda'
  gem 'minitest-rails-capybara'
  gem 'mocha'

  # test suite additions
  gem 'rails_best_practices'
  gem 'brakeman' # security test: execute with 'brakeman'
  gem 'rubocop' # style enforcement
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
