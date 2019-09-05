Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'welcome#home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#end'

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

  get '/orders/new', to: 'orders#new'
  post '/orders', to: 'orders#create'
  get '/orders/:order_id', to: 'orders#show'
  get '/user/profile/orders', to: 'orders#show'

  namespace :user do
    post '/users', to: 'users#create', as: :register
    get '/register', to: 'users#new'
    get '/profile', to: 'users#show'
    get '/profile/edit', to: 'users#edit'
    patch '/profile/edit', to: 'users#update'
    get '/profile/edit_password', to: 'users#edit_password'
    patch '/profile/edit_password', to: 'users#update_password'
  end
end
