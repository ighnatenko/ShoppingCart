# frozen_string_literal: true

module ShoppingCart
  # PaymentForm
  class PaymentForm < Rectify::Form
    attribute :number, String
    attribute :cvv, String
    attribute :expiration_date, String
    attribute :card_name, String

    CVV_REGEXP = /\A\d{3}\z/
    NUMBER_REGEXP = /\A\d{16}\z/
    EXIRATION_DATE_REGEXP = %r{\A(\d{2})\/(\d{2})\z}
    CARD_NAME_REGEXP = /[a-zA-Z]/

    validates :number, :cvv, :expiration_date, :card_name, presence: true
    validates :number, format: { with: NUMBER_REGEXP }
    validates :cvv, format: { with: CVV_REGEXP }
    validates :expiration_date, format: { with: EXIRATION_DATE_REGEXP }
    validates :card_name, format: { with: CARD_NAME_REGEXP }

    def update!(order)
      credit_card(order).update(attributes)
    end

    private

    def credit_card(order)
      credit_card = ShoppingCart::CreditCard.find_by(order_id: order.id)
      credit_card = ShoppingCart::CreditCard.new(order_id: order.id) if credit_card.nil?
      credit_card
    end
  end
end
