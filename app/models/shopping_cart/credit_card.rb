module ShoppingCart
  class CreditCard < ApplicationRecord
    belongs_to :cardable, polymorphic: true

    validates :number, :cvv, :expiration_date, :card_name, presence: true
    validates :number, format: { with: /\A\d{16}\z/ }
    validates :cvv, format: { with: /\A\d{3}\z/ }
    validates :expiration_date, format: { with: /\A(\d{2})\/(\d{2})\z/ }
    validates :card_name, format: { with: /\A[a-zA-Z]{,50}\z/ }
  end
end
