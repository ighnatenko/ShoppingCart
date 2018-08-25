require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  # CouponsController
  class CouponsController < ShoppingCart::ApplicationController
    def create
      ShoppingCart::UseCoupon.call(coupon_params, @current_order) do
        on(:ok) { redirect_to cart_path, notice: t('coupon.added') }
        on(:not_exist) { redirect_to cart_path, alert: t('coupon.not_exist') }
        on(:already_used) { redirect_to cart_path, alert: t('coupon.used') }
      end
    end

    private

    def coupon_params
      params.require(:coupon).permit(:code)
    end
  end
end
