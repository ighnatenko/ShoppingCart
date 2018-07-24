require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  # CouponsController
  class CouponsController < ApplicationController
    def create
      coupon = Coupon.find_by(code: coupon_params[:code])
      return redirect_to cart_path, alert: t('coupon.not_exist') unless coupon
      return redirect_to cart_path, alert: t('coupon.used') if coupon.order
      @order = @current_order
      @order.update(coupon: coupon)
      redirect_to cart_path, notice: t('coupon.added')
    end

    private

    def coupon_params
      params.require(:coupon).permit(:code)
    end
  end
end
