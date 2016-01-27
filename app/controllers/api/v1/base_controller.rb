class Api::V1::BaseController < ApplicationController
  attr_reader :current_user

  include PaginationHelpers

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :authenticate_user!

  private
    def authenticate_user!
      token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
      user = User.find_by(email: options.try(:[], :email))

      # http://codahale.com/a-lesson-in-timing-attacks/
      if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
        set_current_user(user)
      else
        unauthenticated! and return
      end
    end

    def unauthenticated!
      # http://stackoverflow.com/questions/3297048/403-forbidden-vs-401-unauthorized-http-responses
      response.headers['WWW-Authenticate'] = 'Token realm=Application'
      render json: { message: 'Bad credentials' }, status: :unauthorized
    end

    def not_found
      render json: { message: 'Not Found' }, status: :not_found
    end

    def set_current_user(user)
      @current_user = user
    end
end
