require "shopping_cart/engine"

module ShoppingCart
  mattr_accessor :user_class
  @@user_class = 'User'

  mattr_accessor :book_class
  @@book_class = 'Book'

  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  def self.setup
    yield self
  end
end