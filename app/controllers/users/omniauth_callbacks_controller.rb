# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # The passthru action is inherited from Devise::OmniauthCallbacksController
  # It will be called for authorization requests that should be intercepted by OmniAuth middleware

  # Google OAuth2 callback handler
  def google_oauth2
    auth_data = request.env["omniauth.auth"]

    # Check if user already exists with this Google account
    @user = User.find_for_oauth(auth_data)

    if @user
      # User exists with this Google account, update info and sign in
      @user.update_from_oauth(auth_data)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      # Check if user exists with same email
      existing_user = User.find_by(email: auth_data.dig(:info, :email))
      if existing_user
        # Connect Google account to existing user
        existing_user.connect_oauth_account(auth_data)
        sign_in_and_redirect existing_user, event: :authentication
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else
        # New user - store OAuth data and redirect to role selection
        session["devise.oauth_data"] = auth_data.except(:extra)
        redirect_to new_users_oauth_role_selection_path
      end
    end
  end

  # GitHub OAuth callback handler
  def github
    auth_data = request.env["omniauth.auth"]

    # Check if user already exists with this GitHub account
    @user = User.find_for_oauth(auth_data)

    if @user
      # User exists with this GitHub account, update info and sign in
      @user.update_from_oauth(auth_data)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "GitHub") if is_navigational_format?
    else
      # Check if user exists with same email
      existing_user = User.find_by(email: auth_data.dig(:info, :email))
      if existing_user
        # Connect GitHub account to existing user
        existing_user.connect_oauth_account(auth_data)
        sign_in_and_redirect existing_user, event: :authentication
        set_flash_message(:notice, :success, kind: "GitHub") if is_navigational_format?
      else
        # New user - store OAuth data and redirect to role selection
        session["devise.oauth_data"] = auth_data.except(:extra)
        redirect_to new_users_oauth_role_selection_path
      end
    end
  end

  # Generic failure handler for all OAuth providers
  def failure
    error_type = request.env["omniauth.error.type"]
    error_message = request.env["omniauth.error"]&.message || "Authentication failed"

    # Log error for debugging
    Rails.logger.error "OAuth Error: #{error_type} - #{error_message}"

    # Redirect to sign in page with error message
    redirect_to new_user_session_path,
                alert: "Authentication failed: #{error_message}. Please try again."
  end

  protected

  # Override after_sign_in_path_for method to redirect to appropriate dashboard
  def after_sign_in_path_for(resource)
    # Redirect to the appropriate dashboard based on user role
    case resource.role
    when "admin"
      admin_dashboard_path
    when "trainer"
      trainer_dashboard_path
    when "athlete"
      athlete_dashboard_path
    else
      super
    end
  end

  private

  # Helper method to extract OAuth data
  def oauth_data
    request.env["omniauth.auth"]
  end

  # Helper method to check if OAuth data is valid
  def valid_oauth_data?
    oauth_data.present? &&
    oauth_data[:provider].present? &&
    oauth_data[:uid].present? &&
    oauth_data.dig(:info, :email).present?
  end
end
