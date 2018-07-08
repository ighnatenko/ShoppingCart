class CreateShoppingCartCreditCards < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_credit_cards do |t|
      t.string :number, null: false
      t.string :cvv, null: false
      t.string :card_name, null: false
      t.string :expiration_date, null: false
      t.references :cardable, polymorphic: true, index: { name: 'index_sh_credit_cards_on_cardable_type_and_cardable_id' }
      t.timestamps
    end
  end
end
