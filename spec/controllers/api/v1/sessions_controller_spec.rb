require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :api do
  let(:user) { FactoryGirl.create(:user) }
  let(:session_reponse) { Api::V1::SessionSerializer.new(user) }

  describe '#create' do
    context 'when valid credentials' do
      before { post api_v1_login_path(email: user.email, password: user.password) }

      it 'returns 201 status code' do
        expect(last_response.status).to eq(201)
      end

      it 'returns token with user details' do
        expect(last_response.body).to eq(session_reponse.to_json)
      end
    end

    context 'when invalid credentials' do
      before { post api_v1_login_path }

      it 'returns 401 status code' do
        expect(last_response.status).to eq(401)
      end
    end
  end
end
