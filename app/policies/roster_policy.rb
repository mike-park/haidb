class RosterPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    user.angel && record.has_angel?(user.angel)
  end
end
