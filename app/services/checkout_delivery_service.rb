# frozen_string_literal: true

module ShoppingCart
  # CheckoutDeliveryService
  class CheckoutDeliveryService
    include CheckoutHelper

    attr_reader :deliveries, :updated

    def initialize(order, params = nil)
      @order = order
      @params = params
      @deliveries = Delivery.all
      @updated = false
    end

    def call
      if @params[:delivery].present?
        @updated = true if @order.update(delivery_id: @params[:delivery])
      end
      self
    end
  end
end
