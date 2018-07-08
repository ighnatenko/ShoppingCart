require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  class OrdersController < ApplicationController
    before_action "authenticate_#{ShoppingCart.user_class.downcase}!".to_sym
    
    def index
      authorize! :index, ShoppingCart::Order
      @orders = current_user.orders.newest
      @orders = @orders.by_state(params[:state].to_sym) if valid_state?
    end

    def show
      @order = ShoppingCart::Order.find_by(id: params[:id])
    end

    def confirm
      order = ShoppingCart::Order.find_by_confirmation_token(params[:token])
      if order
        order.update(email_confirmed: true, completed_date: DateTime.now.to_date, state: "delivered")
        redirect_to root_path, notice: t('orders.successful')
      else
        redirect_to root_path, alert: t('orders.not_exist')
      end
    end

    private

    def valid_state?
      ShoppingCart::Order.aasm_states.include?(params[:state]&.to_sym)
    end
  end
end