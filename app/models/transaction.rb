class Transaction < ApplicationRecord
  belongs_to :invoice

  scope :paid, -> { where(result: 'success') }
end
