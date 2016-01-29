class Api::V1::ResourceController < Api::V1::BaseController
  def index
    resources = paginate(self.resources)
    render json: collection_serializer_klass.new(
      resources,
      each_serializer: collection_each_serializer_klass,
      root: controller_name,
      meta: meta_attributes(resources)
    )
  end

  def show
    render json: resource
  end

  def create
    if resource.save
      render json: resource, status: :created
    else
      render json: resource.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if resource.update(resource_params)
      render json: resource, status: :ok
    else
      render json: resource.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if resource.destroy
      render json: { message: 'resource deleted successfully' }, status: :ok
    else
      render json: resource.errors.full_messages, status: :unprocessable_entity
    end
  end

  protected
    def resource
      instance_variable_get("@#{ controller_name.singularize }")
    end

    def resources
      instance_variable_get("@#{ controller_name }")
    end

    def collection_each_serializer_klass
      Api::V1.const_get("#{ controller_name.classify }Serializer")
    end

    def collection_serializer_klass
      ActiveModel::ArraySerializer
    end
end
