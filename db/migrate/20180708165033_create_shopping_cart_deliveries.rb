class CreateShoppingCartDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_deliveries do |t|
      t.string :title, null: false
      t.string :days, null: false
      t.decimal :price, precision: 5, scale: 2, null: false
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
