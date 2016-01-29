require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:text) }
  end

  describe 'Associations' do
    it { should belong_to(:blog) }
    it { should belong_to(:creator).class_name(:User) }
  end
end
