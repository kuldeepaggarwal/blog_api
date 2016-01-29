require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe 'Associations' do
    it { should belong_to(:author).class_name('User') }
  end

  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
