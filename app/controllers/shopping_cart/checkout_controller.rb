require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  # CheckoutController
  class CheckoutController < ApplicationController
    include Wicked::Wizard
    include ShoppingCart::CheckoutHelper
    before_action :authenticate_user!, :set_order

    steps :address, :delivery, :payment, :confirm, :complete

    def show
      redirect_to root_path if @order.books.count.zero?
      case step
      when :address then show_address
      when :delivery then show_delivery
      when :payment then show_payment
      when :confirm  then show_confirm
      when :complete then show_complete
      end
      render_wizard unless performed?
    end

    def update
      case step
      when :address then update_address
      when :delivery then update_delivery
      when :payment then update_payment
      when :confirm  then update_confirm
      when :complete then redirect_to root_path
      end
      redirect_to_valid_step
    end

    private

    def show_address
      @address_service = CheckoutAddressService.new(@order, nil, current_user)
    end

    def show_delivery
      @delivery_service = CheckoutDeliveryService.new(@order)
      jump_to(valid_step) unless address_valid?(@order)
    end

    def show_payment
      @payment_service = CheckoutPaymentService.new(@order, nil, current_user)
      jump_to(valid_step) if @order.delivery.nil?
    end

    def show_confirm
      return jump_to(valid_step) if try_nil_or_invalid?(current_user
        .orders.last.credit_card)
    end

    def show_complete
      return jump_to(valid_step) if try_nil_or_invalid?(current_user
        .orders.last.credit_card)
      @shipping_address = @order.addresses.find_by_address_type(:shipping)
      @order.deliver
    end

    def update_address
      @address_service =
        CheckoutAddressService.new(@order, params, current_user).call
      return if @address_service.billing_address.valid? &&
                @address_service.shipping_address.valid?
      render_wizard
    end

    def update_delivery
      @delivery_service = CheckoutDeliveryService.new(@order, params).call
      return if @delivery_service.updated
      render_wizard
    end

    def update_payment
      @payment_service = CheckoutPaymentService.new(@order, params).call
      return unless try_nil_or_invalid?(@order.credit_card)
      render_wizard
    end

    def redirect_to_valid_step
      if try_nil_or_invalid?(current_user.orders.last.credit_card)
        redirect_to next_wizard_path unless performed?
      else
        check_step(step)
        render_wizard unless performed?
      end
    end

    def check_step(step)
      if step == :confirm
        jump_to(:complete)
      elsif previous_step == :address ||
            previous_step == :delivery ||
            previous_step == :payment
        jump_to(:confirm)
      end
    end

    def update_confirm; end

    def set_order
      @order = @current_order
    end

    def address_valid?(order)
      billing_address = order.addresses.find_by_address_type(:billing)
      shipping_address = order.addresses.find_by_address_type(:shipping)
      !try_nil_or_invalid?(billing_address) &&
        !try_nil_or_invalid?(shipping_address)
    end
  end
end
