class UserPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def index?
    admin?
  end

  def show?
    admin? || owner?
  end

  def create?
    admin?
  end

  def new?
    create?
  end

  def update?
    admin? || owner?
  end

  def edit?
    update?
  end

  def destroy?
    admin?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if admin?
        scope.all
      else
        # Users can only see themselves
        scope.where(id: user.id)
      end
    end
  end
end
