require 'rails_helper'

RSpec.describe Ability do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:blogger) { FactoryGirl.create(:user, :blogger) }
  let(:guest) { FactoryGirl.build(:user, :guest) }
  let(:subject) { Ability.for_user(user) }

  context '.for_user' do
    it { expect(Ability.for_user(admin)).to be_kind_of(AdminAbility) }
    it { expect(Ability.for_user(blogger)).to be_kind_of(BloggerAbility) }
    it { expect(Ability.for_user(guest)).to be_kind_of(GuestAbility) }
    it { expect(Ability.for_user(nil)).to be_kind_of(GuestAbility) }
  end

  context 'when guest' do
    let(:user) { guest }

    it { should_not be_able_to(:index, User) }
  end

  context 'when admin' do
    let(:user) { admin }

    it { should be_able_to(:manage, :all) }
  end

  context 'when blogger' do
    let(:user) { blogger }

    it { should_not be_able_to(:index, User) }
    it { should have_abilities([:show, :destroy, :update], user) }
    it { should not_have_abilities([:show, :destroy, :update], admin) }
  end
end