module ShoppingCart
  # CheckoutHelper
  module CheckoutHelper
    def user_order
      current_user.orders.last
    end

    def valid_step
      case true
      when empty_address?(user_order) then :address
      when user_order.delivery.nil? then :delivery
      when user_order.credit_card.nil? then :payment
      else :payment
      end
    end

    def empty_address?(order)
      order.addresses.find_by_address_type(:billing).nil? ||
        order.addresses.find_by_address_type(:shipping).nil?
    end
  end
end
