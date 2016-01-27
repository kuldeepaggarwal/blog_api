class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user!

  def create
    if user = User.find_by(email: params[:email]) and user.authenticate(params[:password])
      render json: Api::V1::SessionSerializer.new(user), status: 201
    else
      render json: {}, status: :unauthorized
    end
  end
end
