class Api::V1::CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :blog_id, :creator_id
end
