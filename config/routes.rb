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

  resources :orders, only: [:new, :create]
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
  get '/admin', to: 'admin/dashboard#index', as: :admin_dash
  get '/admin/users', to: 'admin/dashboard#users'

end
