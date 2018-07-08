ShoppingCart::Engine.routes.draw do
  root to: 'orders#index'

  put 'checkout_address', to: 'checkout#address'
  put 'checkout_delivery', to: 'checkout#delivery'
  put 'checkout_payment', to: 'checkout#payment'
  put 'checkout_confirm', to: 'checkout#confirm'
  put 'checkout_complete', to: 'checkout#complete'

  get 'cart', to: 'cart#index'
  delete 'cart', to: 'cart#destroy'
  post 'cart_item', to: 'cart#add_item'
  put 'cart_decrement_item', to: 'cart#decrement'
  put 'cart_increment_item', to: 'cart#increment'

  resources :orders, only: %i[index show] do 
    get '/confirm/:token', to: 'orders#confirm', as: 'confirm'
  end
  resources :coupons, only: :create
end
