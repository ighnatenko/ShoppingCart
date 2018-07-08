require 'test_helper'

module ShoppingCart
  class CheckoutControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get address" do
      get checkout_address_url
      assert_response :success
    end

    test "should get complete" do
      get checkout_complete_url
      assert_response :success
    end

    test "should get confirm" do
      get checkout_confirm_url
      assert_response :success
    end

    test "should get delivery" do
      get checkout_delivery_url
      assert_response :success
    end

    test "should get payment" do
      get checkout_payment_url
      assert_response :success
    end

  end
end
