module ShoppingCart
  # Ability
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= ShoppingCart.user_class.constantize.new

      can :read, :all
      can %i[read confirm], Order, user_id: user.id

      if user.admin
        can :manage, :all
      elsif user.confirmed_at
        can %i[create update], CreditCard, user_id: user.id
        can %i[read create update], Address, user_id: user.id
      end
    end
  end
end
