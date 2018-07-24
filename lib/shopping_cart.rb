require 'shopping_cart/engine'

# ShoppingCart
module ShoppingCart
  mattr_accessor :user_class
  mattr_accessor :book_class
  mattr_accessor :parent_controller

  @@user_class = 'User'
  @@book_class = 'Book'
  @@parent_controller = 'ApplicationController'

  def self.setup
    yield self
  end
end
