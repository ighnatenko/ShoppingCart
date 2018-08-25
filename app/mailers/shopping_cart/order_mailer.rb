module ShoppingCart
  class OrderMailer < ApplicationMailer
    def order_confirmation(user, order)
      @url = order_confirm_url(order, order.confirmation_token)
      mail(to: user.email, subject: 'Please confirm your order to continue')
    end
  end
end
