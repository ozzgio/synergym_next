# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Default permissions - override in specific policies as needed
  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def new?
    create?
  end

  def update?
    admin?
  end

  def edit?
    update?
  end

  def destroy?
    admin?
  end

  # Role-based helper methods
  private

  def admin?
    user&.admin?
  end

  def trainer?
    user&.trainer?
  end

  def athlete?
    user&.athlete?
  end

  # Check if user can access their own record
  def owner?
    user == record
  end

  # Check if user can access record associated with them
  def associated?
    # Override in specific policies as needed
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope

    # Helper methods for scopes
    def admin?
      user&.admin?
    end

    def trainer?
      user&.trainer?
    end

    def athlete?
      user&.athlete?
    end
  end
end
