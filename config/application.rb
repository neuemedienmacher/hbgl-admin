require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)
require 'clarat_base'

module Claradmin
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    # Default is UTC.
    config.time_zone = 'Berlin'

    # Custom directories with classes and modules you want to be autoloadable.
    additional_paths = %W(
      #{config.root}/app/workers
      #{config.root}/app/concepts
      #{config.root}/app/lib/claradmin
    )
    config.autoload_paths += additional_paths
    config.eager_load_paths += additional_paths

    # Activate observers that should always be running.
    config.active_record.observers = %w(
      location_observer offer_observer organization_observer
    )

    # Trailblazer config
    # config.cells.with_assets = ['backend/form_fields/filtering_select_cell']
  end
end
