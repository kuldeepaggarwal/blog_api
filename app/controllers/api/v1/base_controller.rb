class Api::V1::BaseController < ApplicationController
  include PaginationHelpers

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
    def not_found
      render json: { message: 'Not Found' }, status: :not_found
    end
end
