# frozen_string_literal: true

class DashboardPolicy < ApplicationPolicy
  # Dashboard access based on user roles

  def athlete?
    user&.athlete?
  end

  def trainer?
    user&.trainer? || user&.admin?
  end

  def admin?
    user&.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # For dashboards, we don't typically need scopes
      # but this is included for completeness
      scope.all
    end
  end
end
