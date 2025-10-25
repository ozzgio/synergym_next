# frozen_string_literal: true

# Only configure Sidekiq if Redis is available
begin
  # Test Redis connection
  redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")
  Redis.new(url: redis_url).ping

  # Configure SSL options for Redis if using rediss://
  redis_options = { url: redis_url }
  if redis_url.start_with?("rediss://")
    redis_options[:ssl_params] = { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  Sidekiq.configure_server do |config|
    config.redis = redis_options
  end

  Sidekiq.configure_client do |config|
    config.redis = redis_options
  end
rescue => e
  Rails.logger.warn "Sidekiq could not connect to Redis: #{e.message}"
  Rails.logger.warn "Background jobs will not be processed until Redis is started"

  # Create a dummy configuration to prevent errors
  Sidekiq.configure_server do |config|
    # Dummy configuration
  end

  Sidekiq.configure_client do |config|
    # Dummy configuration
  end
end
