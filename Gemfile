source 'https://rubygems.org'



###########
# General #
###########

gem 'rails', '4.1.13'
gem 'bundler', '>= 1.8.4'

gem 'clarat_base', path: '../clarat_base/'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 4.1.12'
gem 'rails-observers' # observers got extracted since rails 4

# Translations
gem 'rails-i18n'

# Platforms Ruby
platforms :ruby do
  gem 'sqlite3', group: :test # sqlite3 for inmemory testing db
  gem 'therubyracer' # js runtime
  gem 'pg', group: [:production, :staging, :development] # postgres
end
