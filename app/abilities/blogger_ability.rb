class BloggerAbility < Ability
  def initialize(user)
    can [:show, :destroy, :update], User, { id: user.id }
    super
  end
end
