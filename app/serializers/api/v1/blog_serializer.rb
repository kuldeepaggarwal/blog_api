class Api::V1::BlogSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_one :author, serializer: Api::V1::UserSerializer
end
