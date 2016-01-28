class Api::V1::UsersController < Api::V1::BaseController
  load_and_authorize_resource

  def show
    render json: @user
  end

  def index
    users = paginate(User.all)
    render json: ActiveModel::ArraySerializer.new(
      users,
      each_serializer: Api::V1::UserSerializer,
      root: 'users',
      meta: meta_attributes(users)
    )
  end

  def destroy
    if @user.destroy
      render json: { message: 'resource deleted successfully' }, status: :ok
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def create
    user = User.new(resource_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(resource_params)
      render json: @user, status: :ok
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
    def resource_params
      params.require(:user)
      .permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
end
