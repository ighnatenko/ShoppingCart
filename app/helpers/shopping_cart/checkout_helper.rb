module ShoppingCart
  # CheckoutHelper
  module CheckoutHelper
    def try_nil_or_invalid?(object)
      object.nil? || object.invalid?
    end

    def valid_step
      case true
      when valid_address? then :address
      when try_nil_or_invalid?(current_user.orders.last.delivery) then :delivery
      when try_nil_or_invalid?(current_user.orders.last.credit_card) then :payment
      else :payment
      end
    end

    def valid_address?
      try_nil_or_invalid?(current_user.orders.last.addresses
        .find_by_address_type(:billing)) ||
        try_nil_or_invalid?(current_user.orders.last.addresses
        .find_by_address_type(:shipping))
    end
  end
end
