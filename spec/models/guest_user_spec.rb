require 'rails_helper'

RSpec.describe GuestUser, type: :model do
  describe '.new' do
    subject { described_class.new }

    it { should be_an_instance_of(User) }
    it { should be_guest }
  end
end
