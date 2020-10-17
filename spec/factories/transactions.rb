FactoryBot.define do
  factory :transaction do
    invoice_id { 1 }
    cc_num { [1..100000].sample.to_s }
    result { "Success" }
  end
end
