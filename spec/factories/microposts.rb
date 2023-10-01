FactoryBot.define do
  factory :micropost do
    content { Faker::Lorem.sentence(word_count: 5) }
    sequence(:created_at) { |n| (n + 1).minutes.ago }
    association :user

    trait :most_recent do
      created_at { Time.zone.now }
    end
  end
end
