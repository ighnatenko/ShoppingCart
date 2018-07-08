module ShoppingCart
  class Delivery < ApplicationRecord
    has_many :orders, dependent: :nullify, class_name: 'ShoppingCart::Order'
    validates :title, :days, :price, presence: true
  end
end
