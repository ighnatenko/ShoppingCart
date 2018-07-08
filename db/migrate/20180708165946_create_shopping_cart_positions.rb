class CreateShoppingCartPositions < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_positions do |t|
      t.bigint :book_id
      t.bigint :order_id
      t.integer :quantity, default: 0
      t.timestamps
    end
  end
end
