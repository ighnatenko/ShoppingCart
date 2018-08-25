require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  class OrdersController < ShoppingCart::ApplicationController
    # authorize_resource class: 'ShoppingCart::Order'

    def index
      @orders = current_user.orders.newest
      @orders = @orders.by_state(params[:state].to_sym) if valid_state?
      render 'shopping_cart/orders/index'
    end
  
    def show
      @order = ShoppingCart::Order.find(params[:id])
      render 'shopping_cart/orders/show'
    end
  
    def confirm
      order = ShoppingCart::Order.find_by_confirmation_token(params[:token])
      if order
        order.update(email_confirmed: true,
                     completed_date: DateTime.now.to_date,
                     state: 'delivered')
        redirect_to main_app.root_path, notice: t('orders.successful')
      else
        redirect_to main_app.root_path, alert: t('orders.not_exist')
      end
    end
  
    private
  
    def valid_state?
      ShoppingCart::Order.aasm_states.include?(params[:state]&.to_sym)
    end
  end
end