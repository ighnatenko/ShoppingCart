module ShoppingCart
  module CurrentOrder
    def present_order
      @current_order ||= order_from_current_user || order_from_session
      return unless @current_order.nil? || !@current_order.in_progress?
      @current_order = new_order
    end

    private

    def order_from_current_user
      order = current_user&.orders&.find_by(state: 'in_progress')
      session[:order_id] = order.id if order
      order
    end

    def order_from_session
      Order.find_by(id: session[:order_id])
    end

    def new_order
      tracking_number = "R#{Time.now.strftime('%d%m%y%H%M%S')}"
      order = Order.create(user: current_user, tracking_number: tracking_number)
      session[:order_id] = order.id
      order
    end
  end
end