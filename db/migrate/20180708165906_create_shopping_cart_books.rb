class CreateShoppingCartBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_books do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :width, precision: 4, scale: 1, null: false
      t.decimal :height, precision: 4, scale: 1, null: false
      t.decimal :depth, precision: 4, scale: 1, null: false
      t.integer :publication_year, null: false
      t.string :materials, null: false
      t.bigint :category_id
      t.integer :quantity, default: 0
      t.timestamps
    end
  end
end
