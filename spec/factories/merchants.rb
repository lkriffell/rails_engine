FactoryBot.define do
  factory :merchant do
    name { Faker::Cannabis.brand }
  end
end
