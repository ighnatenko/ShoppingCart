module ShoppingCart
  class ApplicationController < ShoppingCart.parent_controller.constantize
    protect_from_forgery with: :exception
    before_action :present_order, :set_locale
  
    [CanCan::AccessDenied, ActiveRecord::RecordNotFound, ActionController::RoutingError].each do |error|
      rescue_from error do |exception|
        redirect_to main_app.root_path, alert: exception.message
      end
    end

    define_method "authenticate_#{ShoppingCart.user_class.downcase}!" do
      return if current_user
      redirect_to root_path, alert: t('checkout.authorize')
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def default_url_options(*)
      { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
    end

    def present_order
      @_current_order ||= order_from_current_user || order_from_session

      if @_current_order == nil || !@_current_order.in_progress?
        @_current_order = new_order
      end
    end
  
    private
  
    def order_from_current_user
      order = current_user&.orders&.find_by(state: 'in_progress')
      session[:order_id] = order.id if order
      order
    end
  
    def order_from_session
      ShoppingCart::Order.find_by(id: session[:order_id])
    end
  
    def new_order
      tracking_number = "R#{Time.now.strftime('%d%m%y%H%M%S')}"
      order = ShoppingCart::Order.create(user: current_user, tracking_number: tracking_number)
      session[:order_id] = order.id
      order 
    end
  end
end
