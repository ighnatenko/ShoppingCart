class CreateShoppingCartOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_orders do |t|
      t.decimal :summary_price, precision: 10, scale: 2
      t.bigint :user_id
      t.boolean :use_billing, default: false, null: false
      t.datetime :completed_date
      t.boolean :email_confirmed, default: false
      t.string :confirmation_token
      t.string :state, default: 'in_progress'
      t.string :tracking_number
      t.decimal :total_price, precision: 10, scale: 2, default: '0.0'
      t.bigint :delivery_id
      t.timestamps
    end
  end
end
