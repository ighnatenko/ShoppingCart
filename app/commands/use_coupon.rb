# frozen_string_literal: true

module ShoppingCart
  # UseCoupon
  class UseCoupon < Rectify::Command
    def initialize(params, order)
      @params = params
      @order = order
    end

    def call
      coupon = ShoppingCart::Coupon.find_by(code: @params[:code])

      return broadcast(:not_exist) unless coupon
      return broadcast(:already_used) if coupon.order

      update_order_with_coupon(coupon)

      broadcast(:ok)
    end

    def update_order_with_coupon(coupon)
      @order.update(coupon: coupon)
    end
  end
end
