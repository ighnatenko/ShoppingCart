require_dependency 'shopping_cart/application_controller'

module ShoppingCart
  # CartController
  class CartController < ApplicationController
    before_action :set_order

    def index
      @items = @order.books
    end

    def add_item
      if @order.books.where(id: items_params[:book_id]).any?
        return redirect_to cart_path, alert: t('cart.alredy_added')
      end
      create_position
    end

    def destroy
      @order.books.delete(Book.find(params[:book_id]))
      redirect_to cart_path, notice: t('cart.removed')
    end

    def increment
      change_quantity(true, @order, params[:book_id])
      redirect_to cart_path
    end

    def decrement
      change_quantity(false, @order, params[:book_id])
      redirect_to cart_path
    end

    private

    def set_order
      @order = @current_order
    end

    def change_quantity(increment, order, book_id)
      position = Position.find_by(order_id: order.id, book_id: book_id)
      quantity = position.quantity
      quantity = increment ? quantity + 1 : quantity - 1
      quantity = 1 if quantity < 1
      position.update(quantity: quantity)
    end

    def items_params
      params.require(:items).permit(:price, :quantity, :book_id)
    end

    def create_position
      Position.create(order_id: @order.id, book_id: items_params[:book_id],
                      quantity: items_params[:quantity].to_i)
      redirect_to cart_path, notice: t('cart.successful_added')
    end
  end
end
