FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{ n }@example.com" }
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    password '12345'
    password_confirmation '12345'

    %i(guest blogger admin).each do |_role|
      trait _role do
        role _role
      end
    end
  end
end
