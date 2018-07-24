module ShoppingCart
  # Address
  class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true
    validates :firstname, :lastname, :address, :zipcode, :city,
              :country, :phone, :address_type, presence: true
    enum address_type: %i[billing shipping]
  end
end
