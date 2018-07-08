require 'test_helper'

module ShoppingCart
  class CartControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get cart_index_url
      assert_response :success
    end

  end
end
