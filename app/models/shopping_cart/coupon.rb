module ShoppingCart
  # Coupon
  class Coupon < ApplicationRecord
    belongs_to :order, optional: true, class_name: 'ShoppingCart::Order'
    validates :code, :discount, presence: true
    validates :code, length: { in: 6..10 }
  end
end
