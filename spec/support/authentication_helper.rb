module AuthenticationHelper
  def sign_in(user)
    __set_header__("Token token=\"#{user.authentication_token}\", email=\"#{user.email}\"")
  end

  def create_and_sign_in_user
    FactoryGirl.create(:user).tap { |user| sign_in(user) }
  end
  alias_method :create_and_sign_in_another_user, :create_and_sign_in_user

  private
    def __set_header__(value)
      header('Authorization', value)
    end
end
