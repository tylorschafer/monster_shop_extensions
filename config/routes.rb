Rails.application.routes.draw do
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

  resources :orders, only: [:new, :create, :update]
  get '/orders/:order_id', to: 'orders#show'
  get '/profile/orders/:order_id', to: 'orders#show'
  get '/profile/orders', to: 'orders#index'

  post '/users', to: 'users#create'
  get '/register', to: 'users#new'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile/edit', to: 'users#update'
  get '/profile/edit_password', to: 'users#edit_password'
  patch '/profile/edit_password', to: 'users#update_password'

  get '/merchant', to: 'merchant/dashboard#index', as: :merchant_dash
  get '/merchant/items', to: 'merchant/dashboard#items'
  patch '/merchant/items/:id', to: 'merchant/items#update', as: :merchant_update_item
  delete '/merchant/items/:id', to: 'merchant/items#destroy', as: :merchant_delete_item
  get '/merchant/orders/:id', to: 'merchant/dashboard#order_show', as: :merchant_order_show
  post '/merchant/orders/:order_id/items/:item_id', to: 'merchant/items#fulfill_item', as: :merchant_fulfill_item

  get '/admin', to: 'admin/dashboard#index', as: :admin_dash
  get '/admin/users', to: 'admin/users#index'
  get '/admin/users/:id', to: 'users#show'
  get '/admin/merchants/:id', to: 'merchant/dashboard#index'
  patch '/admin/merchants/:id', to: 'admin/merchants#update'
end
