### SimpleCOV ###

require 'simplecov'
require 'coveralls'

SimpleCov.start 'rails' do
  add_filter "/test/"
  add_filter "/app/lib/enable_eager_loading.rb"
  add_filter "/lib/rails_admin_extensions/rails_admin_new.rb"
  add_filter "/lib/rails_admin_extensions/rails_admin_delete.rb"
  add_filter "/lib/rails_admin_extensions/rails_admin_change_state.rb"
  add_filter "/app/models/concerns/rails_admin_param_hack.rb"
  add_filter "/app/models/ability.rb" # throw this away with rails_admin
  add_filter "/app/concepts/lib/macros/debug.rb"
  # no way to test connection right now:
  add_filter "/app/channels/application_cable/connection.rb"
  # add_filter "/app/workers/subscribed_emails_mailings_spawner_worker.rb"
  # add_filter "/app/workers/uninformed_emails_mailings_spawner_worker.rb"
  minimum_coverage 100
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

# Coveralls.wear!('rails')
