require 'rails_helper'

RSpec.describe Api::V1::UserSerializer, type: :serializer do
  let(:serialization_data) { { id: 1, name: 'Kuldeep ', email: 'kd.engineer@yahoo.co.in' } }
  let(:resource) { FactoryGirl.build(:user, id: serialization_data[:id], first_name: 'Kuldeep', last_name: '', email: serialization_data[:email]) }
  let(:serializer) { described_class.new(resource) }
  let(:serialization) { serializer.as_json }

  it 'returns id, name & email' do
    expect(serialization).to eq(serialization_data)
  end
end
