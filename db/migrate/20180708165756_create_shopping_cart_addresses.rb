class CreateShoppingCartAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_addresses do |t|
      t.string :address, null: false
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :country, null: false
      t.string :city, null: false
      t.string :zipcode, null: false
      t.string :phone, null: false
      t.integer :address_type
      t.references :addressable, polymorphic: true, index: { name: 'index_sh_addresses_on_addressable_type_and_addressable_id' }
      t.timestamps
    end
  end
end
