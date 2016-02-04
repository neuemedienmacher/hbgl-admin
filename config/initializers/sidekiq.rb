Sidekiq.configure_server do |config|
  config.redis = { url: ENV[ENV['REDIS_PROVIDER']], network_timeout: 5}
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV[ENV['REDIS_PROVIDER']], network_timeout: 5}
end
