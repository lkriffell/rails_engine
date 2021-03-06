class Item < ApplicationRecord
  validates :name, :description, :unit_price, :merchant_id, presence: true
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
end
