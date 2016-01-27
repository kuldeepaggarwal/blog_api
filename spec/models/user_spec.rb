require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build(:user, password: nil) }

  describe 'Validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:password) }
    it { should validate_confirmation_of(:password) }
    it { should validate_length_of(:password).is_at_least(5) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_values('a@abc.com', 'kd@yahoo.co').for(:email) }
  end

  describe 'Callbacks' do
    describe 'after_destroy' do
      it 'does not allow last user to be deleted' do
        subject.update_attributes(password: '12345', password_confirmation: '12345')
        subject.destroy
        expect(FactoryGirl.create(:user).destroy).to be_destroyed
        expect(subject).to_not be_destroyed
      end
    end
  end
end
