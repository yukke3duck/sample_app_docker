FactoryBot.define do
  factory :user, aliases: %i[follower followed] do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password_digest { User.digest('password') }
    activated { true }
    activated_at { Time.zone.now }

    trait :michael do
      name { 'Michael Example' }
      email { 'michael@example.com' }
      admin { true }
    end

    trait :inactive do
      name { 'Inactive User' }
      email { 'inactive@example.com' }
      admin { false }
      activated { false }
    end
  end
end
