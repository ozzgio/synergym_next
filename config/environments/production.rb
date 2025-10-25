require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Serve static files through Rails for Heroku
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}",
    "X-Content-Type-Options" => "nosniff"
  }

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process memory cache store with a durable alternative.
  config.cache_store = :solid_cache_store

  # Replace the default in-process and non-durable queuing backend for Active Job.
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true

  # Set host to be used by links generated in mailer templates.
  # This should be updated to your actual domain in production
  config.action_mailer.default_url_options = {
    host: ENV.fetch("APPLICATION_HOST", "example.com"),
    protocol: "https"
  }

  # Specify outgoing SMTP server. Configure for SendGrid (commonly used with Heroku)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: Rails.application.credentials.dig(:smtp, :user_name) || ENV.fetch("SENDGRID_USERNAME", "apikey"),
    password: Rails.application.credentials.dig(:smtp, :password) || ENV.fetch("SENDGRID_PASSWORD", nil),
    address: Rails.application.credentials.dig(:smtp, :address) || ENV.fetch("SMTP_ADDRESS", "smtp.sendgrid.net"),
    port: Rails.application.credentials.dig(:smtp, :port) || ENV.fetch("SMTP_PORT", 587),
    authentication: "plain",
    enable_starttls_auto: true,
    domain: ENV.fetch("APPLICATION_HOST", "herokuapp.com"),
    openssl_verify_mode: "none" # Use 'none' for self-signed certificates, remove for production
  }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # Configure allowed hosts for production
  config.hosts = [
    ENV.fetch("APPLICATION_HOST", "localhost"),  # Allow requests from the configured host
    /.*\.herokuapp\.com/,                       # Allow all Heroku subdomains
    "localhost",                                # Allow localhost for health checks
    "127.0.0.1"                                 # Allow IP address for health checks
  ]

  # Skip DNS rebinding protection for the default health check endpoint.
  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
