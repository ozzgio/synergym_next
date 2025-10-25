# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def athlete
    authorize :dashboard, :athlete?
    # Placeholder for athlete dashboard
    # Will be enhanced later
  end

  def trainer
    authorize :dashboard, :trainer?
    # Placeholder for trainer dashboard
    # Will be enhanced later
  end

  def admin
    authorize :dashboard, :admin?
    # Placeholder for admin dashboard
    # Will be enhanced later
  end
end
