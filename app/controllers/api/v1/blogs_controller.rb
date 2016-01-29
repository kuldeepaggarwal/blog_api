class Api::V1::BlogsController < Api::V1::ResourceController
  skip_before_action :authenticate_user!, only: [:show, :index]

  before_action :set_blogs, only: :index
  load_resource only: :show

  with_options only: [:create, :update, :destroy] do
    load_and_authorize_resource :user
    load_and_authorize_resource :blog, through: :user, shallow: true
  end

  private
    def set_blogs
      @blogs = Blog.all.includes(:author)
    end

    def resource_params
      params.require(:blog).permit(:title, :description)
    end
end
