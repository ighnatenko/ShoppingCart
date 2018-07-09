module ShoppingCart
  class Order < ApplicationRecord
    include AASM
    belongs_to :user, optional: true, class_name: ShoppingCart.user_class
    has_many :addresses, as: :addressable, dependent: :destroy
    has_one :credit_card, as: :cardable, dependent: :destroy, class_name: 'ShoppingCart::CreditCard'
    has_many :positions, class_name: 'ShoppingCart::Position'
    has_many :books, through: :positions, dependent: :destroy, class_name: ShoppingCart.book_class
    belongs_to :delivery, optional: true, class_name: 'ShoppingCart::Delivery'
    has_one :coupon, class_name: 'ShoppingCart::Coupon'
    
    validates :tracking_number, :state, presence: true
    
    scope :newest, -> { order('created_at DESC') }
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
      if self.confirmation_token.blank?
        self.confirmation_token = SecureRandom.urlsafe_base64.to_s
        self.save(validate: false)
      end
    end

    def send_confirmation
      set_confirmation_token
      ShoppingCart::OrderMailer.order_confirmation(user, self).deliver_now
    end
  end
end
