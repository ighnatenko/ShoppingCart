# frozen_string_literal: true

module ShoppingCart
  # AddressFieldsForm
  class AddressFieldsForm < Rectify::Form
    attribute :firstname, String
    attribute :lastname, String
    attribute :address, String
    attribute :city, String
    attribute :country, String
    attribute :zipcode, String
    attribute :phone, String
    attribute :address_type, String

    validates :firstname, :lastname, :address, :zipcode, :city,
              :country, :phone, :address_type, presence: true
  end
end
