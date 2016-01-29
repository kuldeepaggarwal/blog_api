FactoryGirl.define do
  factory :blog do
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentences(10).join("\n") }

    after(:build) do |blog|
      blog.author = FactoryGirl.build(:user)
    end
  end
end
