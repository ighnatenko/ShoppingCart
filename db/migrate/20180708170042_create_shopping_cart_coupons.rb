class CreateShoppingCartCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_coupons do |t|
      t.bigint :order_id
      t.string :code, null: false
      t.decimal :discount, null: false
      t.timestamps
    end
  end
end
