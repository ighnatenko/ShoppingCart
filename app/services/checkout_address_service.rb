# frozen_string_literal: true

module ShoppingCart
  # CheckoutAddressService
  class CheckoutAddressService
    attr_reader :billing_address, :shipping_address

    def initialize(order, params = nil, current_user = nil)
      @order = order
      @params = params
      initialize_address(current_user) unless current_user.nil?
    end

    def call
      unless @params[:billing_address].present? &&
             @params[:shipping_address].present?
        return self
      end
      @params[:billing_address].present? && @params[:shipping_address].present?
      @order.update(use_billing: @params[:use_billing] || false)
      @billing_address =
        update_address_with_type(@order, :billing, billing_address_params)
      shipping_params = address_params
      shipping_params[:address_type] = :shipping
      @shipping_address =
        update_address_with_type(@order, :shipping, shipping_params)
      self
    end

    private

    def address_params
      if @params[:use_billing]
        billing_address_params
      else
        shipping_address_params
      end
    end

    def billing_address_params
      @params.require(:billing_address)
             .permit(:firstname, :lastname, :address, :city,
                     :zipcode, :country, :phone, :address_type)
    end

    def shipping_address_params
      @params.require(:shipping_address)
             .permit(:firstname, :lastname, :address, :city,
                     :zipcode, :country, :phone, :address_type)
    end

    def initialize_address(current_user)
      @order.update(user: current_user) if @order.user_id.nil?
      @billing_address =
        current_user.addresses.find_by_address_type(:billing) ||
        @order.addresses.find_by_address_type(:billing)
      @shipping_address =
        current_user.addresses.find_by_address_type(:shipping) ||
        @order.addresses.find_by_address_type(:shipping)
    end

    def update_address_with_type(order, address_type, params)
      address = @order.addresses.find_by_address_type(address_type)
      address ? address.update(params) : address = order.addresses.create(params)
      address
    end
  end
end
