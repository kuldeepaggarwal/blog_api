class BloggerAbility < Ability
  def initialize(user)
    can [:show, :destroy, :update], User, { id: user.id }
    can [:create, :destroy, :update], Blog, { user_id: user.id }
    super
  end
end
