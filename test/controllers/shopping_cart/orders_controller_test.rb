require 'test_helper'

module ShoppingCart
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should get index' do
      get orders_index_url
      assert_response :success
    end

    test 'should get show' do
      get orders_show_url
      assert_response :success
    end
  end
end
