module ShoppingCart
  # Position
  class Position < ApplicationRecord
    belongs_to :book, class_name: ShoppingCart.book_class.to_s
    belongs_to :order, class_name: 'ShoppingCart::Order'
    validates :quantity, presence: true
  end
end
