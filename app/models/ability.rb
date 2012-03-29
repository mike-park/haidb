class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, Roster do |roster|
      roster.emails.include?(user.email)
    end

    can :roster, Registration, approved: true, completed: true
  end
end
