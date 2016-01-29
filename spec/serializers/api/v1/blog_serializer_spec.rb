require 'rails_helper'

RSpec.describe Api::V1::BlogSerializer, type: :serializer do
  let(:resource) { FactoryGirl.create(:blog) }
  let(:serializer) { described_class.new(resource) }
  let(:serialization) { serializer.as_json }

  it "returns id, title, description & author's details" do
    expect(serialization).to eq({
      id: resource.id,
      title: resource.title,
      description: resource.description,
      author: Api::V1::UserSerializer.new(resource.author).as_json
    })
  end
end
