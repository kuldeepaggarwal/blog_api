class Api::V1::SessionSerializer < ActiveModel::Serializer
  attributes :id, :email, :token

  def token
    object.authentication_token
  end
end
