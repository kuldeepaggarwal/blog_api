require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :api do
  let(:user) { FactoryGirl.create(:user) }
  let(:serialized_user_response) { Api::V1::UserSerializer.new(user) }

  before { sign_in(user) }

  describe '#show' do
    before { get api_v1_user_path(user.id) }

    it "returns user's data" do
      expect(last_response.body).to eq(serialized_user_response.to_json)
    end

    it 'returs 200 status code' do
      expect(last_response.status).to eq(200)
    end
  end

  describe '#index' do
    let!(:serialized_users_response) do
      {
        users: [serialized_user_response],
        meta: {
          current_page: 1,
          next_page: nil,
          prev_page: nil,
          total_pages: 1,
          total_records: 1
        }
      }.to_json
    end
    before { get api_v1_users_path }

    it 'returns paginated result with metadata' do
      expect(last_response.body).to eq(serialized_users_response)
    end

    it 'returs 200 status code' do
      expect(last_response.status).to eq(200)
    end
  end

  describe '#destroy' do
    context 'when destroyed successfully' do
      before { FactoryGirl.create(:user) }
      before { delete api_v1_user_path(user.id) }

      it 'returns 200 status code' do
        expect(last_response.status).to eq(200)
      end

      it 'returns a success message' do
        expect(last_response.body).to eq({ message: 'resource deleted successfully' }.to_json)
      end
    end

    context 'when destroyed unsuccessful' do
      before { delete api_v1_user_path(user.id) }

      it 'returns 422 status code' do
        expect(last_response.status).to eq(422)
      end

      it 'returns error messages' do
        expect(last_response.body).to eq(["last user can't be deleted"].to_json)
      end
    end
  end

  describe '#create' do
    context 'when created successfully' do
      let(:unsaved_user) { FactoryGirl.build(:user) }
      let(:serialized_user_response) { Api::V1::UserSerializer.new(User.last) }

      before do
        post api_v1_users_path(params: {
          user: unsaved_user.attributes.merge({
            password: '12345',
            password_confirmation: '12345'
          }.stringify_keys)
        })
      end

      it 'returns 201 status code' do
        expect(last_response.status).to eq(201)
      end

      it 'returns user details' do
        expect(last_response.body).to eq(serialized_user_response.to_json)
      end
    end

    context 'when creation failed' do
      before { post api_v1_users_path(params: { user: user.attributes }) }

      it 'returns 422 status code' do
        expect(last_response.status).to eq(422)
      end

      it 'returns error messages' do
        expect(last_response.body).to eq(["Password can't be blank", 'Email has already been taken'].to_json)
      end
    end
  end

  describe '#update' do
    context 'when updated successfully' do
      before do
        put api_v1_user_path(user.id, params: { user: user.attributes.merge({ first_name: 'KD' }.stringify_keys) })
      end

      it 'returns 200 status code' do
        expect(last_response.status).to eq(200)
      end

      it "returns user's updated details" do
        user.reload
        expect(user.first_name).to eq('KD')
        expect(last_response.body).to eq(serialized_user_response.to_json)
      end
    end

    context 'when updation failed' do
      before do
        put api_v1_user_path(user.id, params: { user: user.attributes.merge({ first_name: nil }.stringify_keys) })
      end

      it 'returns 422 status code' do
        expect(last_response.status).to eq(422)
      end

      it 'returns error messages' do
        expect(last_response.body).to eq(["First name can't be blank"].to_json)
      end
    end
  end
end
