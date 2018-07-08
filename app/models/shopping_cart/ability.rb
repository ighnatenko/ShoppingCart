module ShoppingCart
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= ShoppingCart.user_class.constantize.new

      can :manage, Coupon, order_id: order.id
      can %i[create update read confirm], Order, user_id: user.id
      can %i[create update], CreditCard, user_id: user.id
    end
  end
end