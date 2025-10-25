# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # The path used after sign in.
  def after_sign_in_path_for(resource)
    case resource.role
    when "athlete"
      athlete_dashboard_path
    when "trainer"
      trainer_dashboard_path
    when "admin"
      admin_dashboard_path
    else
      super
    end
  end
end
