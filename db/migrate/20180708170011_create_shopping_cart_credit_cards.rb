class CreateShoppingCartCreditCards < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_credit_cards do |t|
      t.string :number
      t.string :cvv
      t.bigint :order_id
      t.string :card_name, null: false
      t.string :expiration_date, null: false

      t.timestamps
    end
  end
end
