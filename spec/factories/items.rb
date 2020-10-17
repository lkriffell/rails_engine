FactoryBot.define do
  factory :item do
    name { Faker::Hipster.word }
    description { Faker::Hipster.sentence }
    unit_price { 63 }
    merchant_id { nil }
  end
end
