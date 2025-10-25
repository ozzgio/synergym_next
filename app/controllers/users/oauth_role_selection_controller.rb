# frozen_string_literal: true

class Users::OauthRoleSelectionController < ApplicationController
  before_action :check_oauth_session
  before_action :redirect_if_signed_in

  # GET /users/oauth/role_selection
  def new
    @oauth_data = session["devise.oauth_data"]
    @provider = @oauth_data&.dig("provider") || @oauth_data&.dig(:provider)
    @step = params[:step] || "role" # "role" or "profile"

    # Initialize user with profile data if available
    @user = build_user_from_oauth_data

    case @step
    when "profile"
      render action: :profile
    else
      render action: :role
    end
  end

  # POST /users/oauth/role_selection
  def create
    @oauth_data = session["devise.oauth_data"]
    @provider = @oauth_data&.dig("provider") || @oauth_data&.dig(:provider)

    case params[:step]
    when "role"
      handle_role_selection
    when "profile"
      handle_profile_completion
    else
      flash.now[:alert] = "Invalid step"
      @step = "role"
      render :role
    end
  end

  protected

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

  def check_oauth_session
    redirect_to new_user_session_path unless session["devise.oauth_data"].present?
  end

  def redirect_if_signed_in
    redirect_to root_path if user_signed_in?
  end

  def build_user_from_oauth_data
    User.new do |user|
      profile_data = user.extract_profile_from_oauth(@oauth_data)
      user.email = @oauth_data&.dig("info", "email") || @oauth_data&.dig(:info, :email)
      user.first_name = profile_data[:first_name] if profile_data[:first_name].present?
      user.last_name = profile_data[:last_name] if profile_data[:last_name].present?
      user.profile_photo_url = profile_data[:profile_photo_url] if profile_data[:profile_photo_url].present?
    end
  end

  def handle_role_selection
    selected_role = params.dig(:user, :role)

    if selected_role.present? && User.roles.key?(selected_role.to_sym)
      # Store selected role in session
      session["devise.oauth_role"] = selected_role
      session["devise.oauth_data_role"] = selected_role

      # Redirect to profile completion step
      redirect_to new_users_oauth_role_selection_path(step: "profile"),
                  notice: "Great! Now let's complete your profile."
    else
      flash.now[:alert] = "Please select a valid role"
      @step = "role"
      @user = build_user_from_oauth_data
      render :role
    end
  end

  def handle_profile_completion
    selected_role = session["devise.oauth_data_role"]
    first_name = params.dig(:user, :first_name)&.strip
    last_name = params.dig(:user, :last_name)&.strip

    if first_name.blank?
      flash.now[:alert] = "First name is required"
      @step = "profile"
      @user = build_user_from_oauth_data
      @user.role = selected_role
      render :profile
      return
    end

    if last_name.blank?
      flash.now[:alert] = "Last name is required"
      @step = "profile"
      @user = build_user_from_oauth_data
      @user.role = selected_role
      render :profile
      return
    end

    # Create user with all information
    @user = User.new
    @user.email = @oauth_data&.dig("info", "email") || @oauth_data&.dig(:info, :email)
    @user.first_name = first_name
    @user.last_name = last_name
    @user.provider = @oauth_data&.dig("provider") || @oauth_data&.dig(:provider)
    @user.uid = @oauth_data&.dig("uid") || @oauth_data&.dig(:uid)
    @user.role = selected_role.to_sym
    @user.password = Devise.friendly_token[0, 20]
    @user.password_confirmation = @user.password

    # Extract profile photo if available
    profile_data = User.new.extract_profile_from_oauth(@oauth_data)
    @user.profile_photo_url = profile_data[:profile_photo_url] if profile_data[:profile_photo_url].present?

    if @user.save
      # Clean up session
      session.delete("devise.oauth_data")
      session.delete("devise.oauth_role")
      session.delete("devise.oauth_data_role")

      # Sign in the user with explicit scope
      provider_name = @provider&.humanize || "OAuth provider"
      sign_in(:user, @user)
      redirect_to after_sign_in_path_for(@user), notice: "Successfully authenticated with #{provider_name}."
    else
      # Handle validation errors
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      @step = "profile"
      @user.role = selected_role.to_sym if selected_role.present?
      render :profile
    end
  end
end
