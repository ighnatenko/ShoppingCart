# frozen_string_literal: true

module ShoppingCart
  # UseCoupon
  class ChangeQuantity < Rectify::Command
    def initialize(order_id, book_id, increment: true)
      @increment = increment
      @order_id = order_id
      @book_id = book_id
    end

    def call
      position = ShoppingCart::Position.find_by(order_id: @order_id, book_id: @book_id)
      quantity = position.quantity
      quantity = @increment ? quantity + 1 : quantity - 1
      quantity = 1 if quantity < 1
      position.update(quantity: quantity)
      broadcast(:ok)
    end
  end
end
