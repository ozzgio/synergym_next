# frozen_string_literal: true

require "sidekiq/web"

Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  # Protect Sidekiq web interface with HTTP Basic Auth
  # In production, use proper credentials from environment variables
  username == ENV.fetch("SIDEKIQ_WEB_USERNAME", "admin") &&
  password == ENV.fetch("SIDEKIQ_WEB_PASSWORD", "admin")
end if Rails.env.production?
