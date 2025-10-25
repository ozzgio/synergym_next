class DebugController < ApplicationController
  def oauth_env
    render json: {
      google_client_id: ENV["GOOGLE_OAUTH_CLIENT_ID"] ? "Present (#{ENV["GOOGLE_OAUTH_CLIENT_ID"][0..20]}...)" : "Missing",
      google_client_secret: ENV["GOOGLE_OAUTH_CLIENT_SECRET"] ? "Present" : "Missing",
      github_client_id: ENV["GITHUB_OAUTH_CLIENT_ID"] ? "Present" : "Missing",
      github_client_secret: ENV["GITHUB_OAUTH_CLIENT_SECRET"] ? "Present" : "Missing",
      devise_omniauth_configs: Devise.omniauth_configs&.keys || [],
      omniauth_middleware: Rails.application.config.middleware.any? { |m| m.name == OmniAuth::Builder }
    }
  end
end
