class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  has_many :items



  attribute :total_revenue do |object|
    object.merchant_revenue
  end

  attribute :items_sold do |object|
    object.items_sold
  end
end
