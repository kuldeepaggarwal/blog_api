class Api::V1::UsersController < Api::V1::ResourceController
  load_and_authorize_resource

  private
    def resource_params
      params.require(:user)
      .permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
end
