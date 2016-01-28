class AdminAbility < Ability
  def initialize(user)
    can :manage, :all
  end
end
