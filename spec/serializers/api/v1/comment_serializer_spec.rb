require 'rails_helper'

RSpec.describe Api::V1::CommentSerializer, type: :serializer do
  let(:resource) { FactoryGirl.create(:comment) }
  let(:serializer) { described_class.new(resource) }
  let(:serialization) { serializer.as_json }

  it "returns id, text, blog_id & creator_id" do
    expect(serialization).to eq({
      id: resource.id,
      text: resource.text,
      blog_id: resource.blog_id,
      creator_id: resource.creator_id
    })
  end
end
