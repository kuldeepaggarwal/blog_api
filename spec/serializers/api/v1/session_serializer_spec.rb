require 'rails_helper'

RSpec.describe Api::V1::SessionSerializer, type: :serializer do
  let(:resource) { FactoryGirl.create(:user) }
  let(:serialization_data) do
    {
      id: resource.id,
      email: resource.email,
      token: resource.authentication_token
    }
  end
  let(:serializer) { described_class.new(resource) }
  let(:serialization) { serializer.as_json }

  it 'returns id, name & email' do
    expect(serialization).to eq(serialization_data)
  end
end
