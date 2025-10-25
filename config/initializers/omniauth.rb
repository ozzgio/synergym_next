# OmniAuth Configuration
# This file is loaded by Rails during initialization
# Devise's config.omniauth calls in devise.rb will use these libraries

require "omniauth"
require "omniauth-google-oauth2"
require "omniauth-github"

# Configure OmniAuth globally
OmniAuth.config.logger = Rails.logger
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

# Allow test mode in development for easier debugging
OmniAuth.config.test_mode = false

# Ensure CSRF protection is working correctly
# The omniauth-rails_csrf_protection gem handles this automatically
OmniAuth.config.allowed_request_methods = [ :post ]

# Enable full logging for debugging CSRF issues
if Rails.env.development?
  OmniAuth.config.logger.level = Logger::DEBUG
end
