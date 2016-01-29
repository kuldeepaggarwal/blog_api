module AuthenticationHelper
  extend ActiveSupport::Concern

  module ClassMethods
    def create_and_sign_in_user(role = :blogger)
      before { create_and_sign_in_user(role) }
    end
    alias_method :create_and_sign_in_blogger, :create_and_sign_in_user

    def sign_in(user_symbol)
      before { sign_in(send(user_symbol)) }
    end
  end

  def sign_in(user)
    __set_header__("Token token=\"#{user.authentication_token}\", email=\"#{user.email}\"")
  end

  def create_and_sign_in_user(role = :blogger)
    FactoryGirl.create(:user, role).tap { |user| sign_in(user) }
  end
  alias_method :create_and_sign_in_blogger, :create_and_sign_in_user

  private
    def __set_header__(value)
      header('Authorization', value)
    end
end
