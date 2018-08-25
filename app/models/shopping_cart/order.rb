module ShoppingCart
  # Order
  class Order < ApplicationRecord
    include AASM
    belongs_to :user, optional: true, class_name: ShoppingCart.user_class.to_s
    has_many :addresses, as: :addressable, dependent: :destroy
    has_one :credit_card, dependent: :destroy, class_name: 'ShoppingCart::CreditCard'
    has_many :positions, class_name: 'ShoppingCart::Position'
    has_many :books, through: :positions, dependent: :destroy, class_name: ShoppingCart.book_class.to_s
    belongs_to :delivery, optional: true, class_name: 'ShoppingCart::Delivery'
    has_one :coupon, class_name: 'ShoppingCart::Coupon'

    validates :tracking_number, :state, presence: true

    scope :newest, (lambda do
      joins(:books)
      .group('shopping_cart_orders.id')
      .having('count(books) > 0')
      .order('created_at DESC')
    end)

    scope :by_state, ->(state) { where(state: state) }

    aasm column: :state do
      state :in_progress, initial: true
      state :in_delivery, after_enter: :send_confirmation
      state :delivered

      event :deliver do
        transitions from: :in_progress, to: :in_delivery
      end

      event :confirm do
        transitions from: :in_delivery, to: :delivered
      end
    end

    def self.aasm_states
      aasm.states.map(&:name)
    end

    def set_confirmation_token
      return unless confirmation_token.blank?
      self.confirmation_token = SecureRandom.urlsafe_base64.to_s
      save(validate: false)
    end

    def send_confirmation
      set_confirmation_token
      ShoppingCart::OrderMailer.order_confirmation(user, self).deliver_now
    end
  end
end
