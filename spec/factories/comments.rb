FactoryGirl.define do
  factory :comment do
    text { Faker::Lorem.sentences(3).join("\n") }
    blog { FactoryGirl.create(:blog) }
    creator { blog.author }
  end
end
