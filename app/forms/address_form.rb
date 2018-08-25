# frozen_string_literal: true

module ShoppingCart
  # AddressForm
  class AddressForm < Rectify::Form
    attr_accessor :shipping_address, :billing_address, :use_billing

    def initialize(params = nil)
      if params
        init_with_params(params)
      else
        init_wihout_params
      end
    end

    def valid?
      billing = @billing_address.valid?
      shipping = @shipping_address.valid?
      billing && shipping
    end

    def update!(order)
      update_address(order, @shipping_address)
      update_address(order, @billing_address)
    end

    private

    def init_with_params(params)
      @use_billing = params[:use_billing] || false

      @billing_address = ShoppingCart::AddressFieldsForm.from_params(params[:billing_form])
      if @use_billing
        @shipping_address = ShoppingCart::AddressFieldsForm.from_params(params[:billing_form])
        @shipping_address.address_type = :shipping
      else
        @shipping_address = ShoppingCart::AddressFieldsForm.from_params(params[:shipping_form])
      end
    end

    def init_wihout_params
      @billing_address = ShoppingCart::AddressFieldsForm.new
      @shipping_address = ShoppingCart::AddressFieldsForm.new
      @use_billing = false
    end

    def update_address(order, address)
      order_address = order.addresses.find_by_address_type(address.address_type)
      if order_address.nil?
        order.addresses.create(address.attributes)
      else
        order_address.update(address.attributes)
      end
    end
  end
end
