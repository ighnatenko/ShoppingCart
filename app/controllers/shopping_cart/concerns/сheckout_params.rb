module CheckoutParams
  extend ActiveSupport::Concern

  included do
    
    def billing_address_params
      params.require(:billing_address).permit(:firstname, :lastname, :address,
      :city, :zipcode, :country, :phone, :address_type)
    end

    def shipping_address_params
      params.require(:shipping_address).permit(:firstname, :lastname, :address,
      :city, :zipcode, :country, :phone, :address_type)
    end

    def credit_card_params
      params.require(:credit_card).permit(:number, :cvv, :expiration_date, :card_name)
    end
  end
end