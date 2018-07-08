require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  class CheckoutController < ApplicationController
    include CheckoutParams
    before_action "authenticate_#{ShoppingCart.user_class.downcase}!".to_sym, :set_order
    
    def address
      @billing_address = @order.addresses.find_by_address_type(:billing)
      @shipping_address = @order.addresses.find_by_address_type(:shipping)
      render :address
    end

    def delivery
      @deliveries = Delivery.all
      set_address_for_order(@order)
      address_valid?(@order) ? (render :delivery) : (render :address)
    end

    def payment
      update_delivery(@order, params) if params[:delivery].present?

      if @order.delivery
        @credit_card = @order.credit_card
        @credit_card = ShoppingCart::CreditCard.new if nil_or_invalid?(@credit_card)
        render :payment
      else
        delivery
      end
    end

    def confirm
      @credit_card = update_credit_card(@order, credit_card_params)
      credit_card_valid?(@order) ? (render :confirm) : (render :payment)
    end

    def complete
      @order.deliver
      @shipping_address = @order.addresses.find_by_address_type(:shipping)
      render :complete
    end

    private

    def set_order
      @order = @_current_order
    end

    def set_address_for_order(order)
      if params[:billing_address].present? && params[:shipping_address].present?
        order.update(use_billing: params[:use_billing] || false)
        @billing_address = update_address(order, :billing, billing_address_params)

        shipping_params = params[:use_billing] ? billing_address_params : shipping_address_params
        shipping_params[:address_type] = :shipping
        @shipping_address = update_address(order, :shipping, shipping_params)
      end
    end

    def address_valid?(order)
      billing_address = order.addresses.find_by_address_type(:billing)
      shipping_address = order.addresses.find_by_address_type(:shipping)
      !(nil_or_invalid?(billing_address) || nil_or_invalid?(shipping_address))
    end

    def credit_card_valid?(order)
      !nil_or_invalid?(order.credit_card)
    end

    def nil_or_invalid?(object)
      object.nil? || object.invalid?
    end

    def update_address(order, address_type, params)
      address = order.addresses.find_by_address_type(address_type)
      address ? address.update(params) : address = order.addresses.create(params)
      address
    end

    def update_credit_card(order, params)
      credit_card = order.credit_card
      credit_card ? credit_card.update(params) : credit_card = order.create_credit_card(params)
      credit_card
    end

    def update_delivery(order, params)
      order.update(delivery_id: params[:delivery])
    end
  end
end