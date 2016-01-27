require 'rails_helper'

RSpec.describe Api::V1::BaseController do
  controller(described_class) do
    def index
      raise ActiveRecord::RecordNotFound
    end
  end

  describe 'handling RecordNotFound exceptions' do
    it 'returns "not found" error message' do
      get :index
      expect(response.body).to eq({ message: 'Not Found' }.to_json)
    end
  end
end
