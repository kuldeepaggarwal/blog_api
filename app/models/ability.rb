class Ability
  include CanCan::Ability

  def initialize(user)
    cannot [:index], User
    can [:show, :index], Blog
  end

  def self.for_user(user)
    user ||= GuestUser.new
    "#{ user.role }_ability".classify.constantize.new(user)
  end
end
