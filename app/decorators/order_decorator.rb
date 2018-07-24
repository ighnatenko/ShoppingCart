module ShoppingCart
  # OrderDecorator
  class OrderDecorator < ApplicationDecorator
    delegate_all
    decorates_association :book
  
    def sale
      coupon ? coupon.discount : 0.0
    end
  
    def subtotal
      sub_total = books.map(&:decorate).map do |item|
        item.total_price(self)
      end.reduce(&:+)
      sub_total || 0.0
    end
  
    def coupon_discount
      subtotal * sale / 100
    end
  
    def shipping
      return 0.to_f if delivery_id.nil?
      Delivery.find_by(id: delivery_id)&.price
    end
  
    def total_without_delivery
      subtotal - coupon_discount
    end
  
    def order_total
      order_total = subtotal - coupon_discount
      order_total += delivery_id.nil? ? 0 : Delivery.find(delivery_id).price
      order_total
    end
end
