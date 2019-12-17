
FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      username { Faker::Name.name }
      password {'123456'}
      password_confirmation {'123456'}
    end
    factory :phrase do
      user
      phrase { Faker::Name.name }
      translation { Faker::Name.name }
      trait :update do
        phrase { Faker::Movies::Ghostbusters.quote }
      end
      trait :invalid do
        phrase { nil }
      end
    end
    factory :example do
      user
      association :phrase, factory: :phrase
      example { Faker::Name.name }
      trait :invalid do
        example { nil }
      end
    end
end