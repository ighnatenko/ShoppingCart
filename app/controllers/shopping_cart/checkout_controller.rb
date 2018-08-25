require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  # CheckoutController
  class CheckoutController < ShoppingCart::ApplicationController
    include Wicked::Wizard
    include ShoppingCart::CheckoutHelper
    include Rectify::ControllerHelpers
    before_action :set_order

    steps :address, :delivery, :payment, :confirm, :complete

    def show
      redirect_to main_app.root_path unless @order.books.exists?
      @order.update(user: current_user) if @order.user_id.nil?
      send("show_#{step}")
      render_wizard unless performed?
    end

    def update
      send("update_#{step}")
      redirect_to_valid_step
    end

    private

    def show_address
      @form = ShoppingCart::AddressForm.new(
        billing_form: address_attributes(@order, :billing),
        shipping_form: address_attributes(@order, :shipping),
        use_billing: @order.use_billing
      )
    end

    def show_delivery
      @deliveries = ShoppingCart::Delivery.all
      jump_to(valid_step) if empty_address?(@order)
    end

    def show_payment
      return jump_to(valid_step) if @order.delivery.nil?
      @form = ShoppingCart::PaymentForm.from_model(@order.credit_card)
    end

    def show_confirm
      return jump_to(valid_step) if user_order.credit_card.nil?
    end

    def show_complete
      return jump_to(valid_step) if user_order.credit_card.nil?
      @shipping_address = @order.addresses.find_by_address_type(:shipping)
      @order.deliver
    end

    def update_address
      use_billing = params[:use_billing] || false
      @order.update(use_billing: use_billing)

      @form = ShoppingCart::AddressForm.from_params(
        address_params, use_billing: params[:use_billing]
      )
      if @form.valid?
        @form.update!(@order)
        return
      end
      render_wizard
    end

    def update_delivery
      @deliveries = ShoppingCart::Delivery.all
      if params[:delivery].present?
        return if @order.update(delivery_id: params[:delivery])
      end
      render_wizard
    end

    def update_payment
      @form = ShoppingCart::PaymentForm.from_params(payment_params)
      if @form.valid?
        @form.update!(@order)
        return
      end
      render_wizard
    end

    def update_confirm
      @order.update(summary_price: @order.decorate.order_total)
    end

    def update_complete
      redirect_to main_app.root_path
    end

    def address_attributes(order, address_type)
      address = order.addresses.find_by_address_type(address_type)
      address ||= current_user.addresses.find_by_address_type(address_type)
      address ? address.attributes : {}
    end

    def redirect_to_valid_step
      if user_order.credit_card.nil?
        redirect_to next_wizard_path unless performed?
      else
        check_step(step)
        render_wizard unless performed?
      end
    end

    def check_step(step)
      return jump_to(:complete) if step == :confirm
      jump_to(:confirm) if %i[address delivery payment].include?(previous_step)
    end

    def set_order
      @order = @current_order
    end

    def address_params
      params.require(:address)
    end

    def payment_params
      params.require(:payment)
    end
  end
end
