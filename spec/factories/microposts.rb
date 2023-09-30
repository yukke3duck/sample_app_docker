FactoryBot.define do
  factory :micropost do
    content { Faker::Lorem.sentence(word_count: 5) }
    created_at { 10.minutes.ago }
    association :user
  end
end
