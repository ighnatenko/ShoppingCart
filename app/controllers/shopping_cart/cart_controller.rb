require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  # CartController
  class CartController < ShoppingCart::ApplicationController
    before_action :set_order

    def index
      @items = @order.books
      render 'shopping_cart/cart/index'
    end

    def add_item
      if @order.books.where(id: items_params[:book_id]).any?
        return redirect_to shopping_cart.cart_path, alert: t('cart.alredy_added')
      end
      create_position
    end

    def destroy
      @order.books.delete(Book.find(params[:book_id]))
      redirect_to shopping_cart.cart_path, notice: t('cart.removed')
    end

    def increment
      change_quantity(increment: true)
    end

    def decrement
      change_quantity(increment: false)
    end

    private

    def set_order
      @order = @current_order
    end

    def change_quantity(increment: true)
      ShoppingCart::ChangeQuantity.call(@order.id, params[:book_id], increment: increment) do
        on(:ok) { redirect_to shopping_cart.cart_path }
      end
    end

    def items_params
      params.require(:items).permit(:price, :quantity, :book_id)
    end

    def create_position
      ShoppingCart::Position.create(order_id: @order.id, book_id: items_params[:book_id],
                                    quantity: items_params[:quantity].to_i)
      redirect_to shopping_cart.cart_path, notice: t('cart.successful_added')
    end
  end
end
