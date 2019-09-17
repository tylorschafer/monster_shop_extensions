Rails.application.routes.draw do
  get 'password_resets/new'

  root to: 'welcome#home'
  get '/', to: 'welcome#home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:create, :new] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

  resources :orders, only: [:new, :create]
  patch '/orders/:id', to: 'orders#cancel', as: :order_cancel
  get '/orders/:order_id', to: 'orders#show', as: :order
  patch '/orders/:order_id/ship', to: 'orders#ship', as: :shipped_order
  get '/profile/orders/:order_id', to: 'orders#show'
  get '/profile/orders/:order_id/addresses/select', to: 'addresses#select', as: :address_select
  get '/profile/orders', to: 'orders#index'

  resources :users
  post '/users', to: 'users#create'
  get '/register', to: 'users#new'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile/edit', to: 'users#update'
  get '/profile/edit_password', to: 'users#edit_password'
  patch '/profile/edit_password', to: 'users#update_password'

  get '/merchant', to: 'merchant/dashboard#index', as: :merchant_dash
  get '/merchant/items', to: 'merchant/dashboard#items'
  get '/merchant/items/new', to: 'merchant/items#new'
  get '/merchant/items/:id/edit', to: 'merchant/items#edit', as: :merchant_edit_item
  post '/merchant/items', to: 'merchant/items#create', as: :merchant_new_item
  patch '/merchant/items/:id/activity', to: 'merchant/items#update_activity', as: :merchant_update_item_activity
  patch '/merchant/items/:id', to: 'merchant/items#update', as: :merchant_update_item
  delete '/merchant/items/:id', to: 'merchant/items#destroy', as: :merchant_delete_item

  get '/merchant/orders/:id', to: 'merchant/dashboard#order_show', as: :merchant_order_show
  post '/merchant/orders/:order_id/items/:item_id', to: 'merchant/items#fulfill_item', as: :merchant_fulfill_item

  get '/merchant/coupons', to: 'merchant/coupons#index', as: :merchant_coupons
  get '/merchant/coupons/new', to: 'merchant/coupons#new', as: :new_coupon
  post '/merchant/coupons/new', to: 'merchant/coupons#create', as: :create_coupon
  get '/merchant/coupons/:coupon_id', to: 'merchant/coupons#edit', as: :edit_coupon
  patch '/merchant/coupons/:coupon_id', to: 'merchant/coupons#update', as: :update_coupon
  delete '/merchant/coupons/:coupon_id', to: 'merchant/coupons#destroy', as: :delete_coupon


  get '/admin', to: 'admin/dashboard#index', as: :admin_dash
  get '/admin/users', to: 'admin/users#index'
  get '/admin/users/:id', to: 'users#show'
  get '/admin/merchants/:id', to: 'admin/merchants#index'
  get '/admin/users/:user_id/orders/:order_id', to: 'orders#show'
  patch '/admin/merchants/:id', to: 'admin/merchants#update'

  resources :password_resets

  resources :addresses

  patch '/orders/addresses/select/:address_id', to: 'orders#select_address'

  match "*path", to: "welcome#catch_404", via: :all
end
