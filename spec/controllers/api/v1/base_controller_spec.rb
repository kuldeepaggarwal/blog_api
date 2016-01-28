require 'rails_helper'

RSpec.describe Api::V1::BaseController do
  include AuthenticationHelper

  # [HACK]: becauase we don't want to make this controller as API,
  # so I preferred to modify and include `AuthenticationHelper` alone here.
  private def __set_header__(value)
    request.set_header('HTTP_AUTHORIZATION', value)
  end

  controller(described_class) do
    def index
      if params[:unauthorized]
        raise CanCan::AccessDenied
      else
        raise ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'handling RecordNotFound exceptions' do
    before { create_and_sign_in_user }

    it 'returns "not found" error message' do
      get :index
      expect(response.body).to eq({ message: 'Not Found' }.to_json)
    end
  end

  describe 'authentication user before filter' do
    before { get :index }

    it 'returns "Bad credentials" error message' do
      expect(response.body).to eq({ message: 'Bad credentials' }.to_json)
    end

    it 'returns 401 status code' do
      expect(response.status).to eq(401)
    end
  end

  describe 'user authorization before filter' do
    before { create_and_sign_in_user }
    before { get :index, params: { unauthorized: true } }

    it 'returns "Not authorized" error message' do
      expect(response.body).to eq({ message: 'Not authorized' }.to_json)
    end

    it 'returns 403 status code' do
      expect(response.status).to eq(403)
    end
  end
end
