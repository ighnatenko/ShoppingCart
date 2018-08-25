ShoppingCart::Engine.routes.draw do
  scope ':locale/', locale: /en|ru/ do
    get '/', to: 'orders#index'
    root to: 'orders#index'

    get 'cart', to: 'cart#index'
    delete 'cart', to: 'cart#destroy'
    post 'cart_item', to: 'cart#add_item'
    put 'cart_decrement_item', to: 'cart#decrement'
    put 'cart_increment_item', to: 'cart#increment'

    resources :checkout
    resources :orders, only: %i[index show] do
      get '/confirm/:token', to: 'orders#confirm', as: 'confirm'
    end

    resources :coupons, only: :create
  end
end
