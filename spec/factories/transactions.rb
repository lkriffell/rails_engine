FactoryBot.define do
  factory :transaction do
    invoice_id { 1 }
    cc_num { 1234543262345 }
    result { "success" }
  end
end
