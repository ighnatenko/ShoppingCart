require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  class CouponsController < ApplicationController
    authorize_resource class: 'ShoppingCart::Coupon'

    def create
      coupon = ShoppingCart::Coupon.find_by(code: coupon_params[:code])
      return redirect_to cart_path, alert: t('coupon.not_exist') unless coupon
      return redirect_to cart_path, alert: t('coupon.used') if coupon.order
      @order = @_current_order
      @order.update(coupon: coupon)
      redirect_to cart_path, notice: t('coupon.added')
    end

    private

    def coupon_params
      params.require(:coupon).permit(:code)
    end
  end
end