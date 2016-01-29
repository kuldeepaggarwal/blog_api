class Api::V1::CommentsController < Api::V1::ResourceController
  load_and_authorize_resource :blog
  load_and_authorize_resource :comment, through: :blog

  private
    def resource_params
      params.require(:comment).permit(:text).merge(creator_id: current_user.id)
    end
end
