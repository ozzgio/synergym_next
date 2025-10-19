FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'athlete' }

    trait :admin do
      role { 'admin' }
    end

    trait :trainer do
      role { 'trainer' }
    end

    trait :athlete do
      role { 'athlete' }
    end
  end
end
