require "sidekiq"
require "sidekiq-status"

Sidekiq.configure_client do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i

  config.redis = {
    url: "redis://#{ENV['REDIS_URL']}"
  }
end

Sidekiq.configure_server do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes.to_i

  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i

  config.redis = {
    url: "redis://#{ENV['REDIS_URL']}"
  }
end
