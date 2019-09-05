# Rails.application.routes.draw do
#   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#   get '/', to: 'welcome#home'
#   get '/register', to: 'users#new'
#   get '/login', to: 'sessions#new'
#   post '/login', to: 'sessions#create'
#   get '/logout', to: 'sessions#end'

#   get '/merchants', to: 'merchants#index'
#   get '/merchants/new', to: 'merchants#new'
#   get '/merchants/:id', to: 'merchants#show'
#   post '/merchants', to: 'merchants#create'
#   get '/merchants/:id/edit', to: 'merchants#edit'
#   patch '/merchants/:id', to: 'merchants#update'
#   delete '/merchants/:id', to: 'merchants#destroy'

#   get '/items', to: 'items#index'
#   get '/items/:id', to: 'items#show'
#   get '/items/:id/edit', to: 'items#edit'
#   patch '/items/:id', to: 'items#update'
#   get '/merchants/:merchant_id/items', to: 'items#index'
#   get '/merchants/:merchant_id/items/new', to: 'items#new'
#   post '/merchants/:merchant_id/items', to: 'items#create'
#   delete '/items/:id', to: 'items#destroy'

#   get '/items/:item_id/reviews/new', to: 'reviews#new'
#   post '/items/:item_id/reviews', to: 'reviews#create'

#   get '/reviews/:id/edit', to: 'reviews#edit'
#   patch '/reviews/:id', to: 'reviews#update'
#   delete '/reviews/:id', to: 'reviews#destroy'

#   post '/cart/:item_id', to: 'cart#add_item'
#   get '/cart', to: 'cart#show'
#   delete '/cart', to: 'cart#empty'
#   delete '/cart/:item_id', to: 'cart#remove_item'
#   patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

#   get '/orders/new', to: 'orders#new'
#   post '/orders', to: 'orders#create'
#   get '/orders/:order_id', to: 'orders#show'

#   get '/profile/orders', to: 'orders#show'

#   post '/users', to: 'users#create', as: :users
#   get '/profile', to: 'users#show'
#   get '/profile/edit', to: 'users#edit'
#   patch '/profile/edit', to: 'users#update'
#   get '/profile/edit_password', to: 'users#edit_password'
#   patch '/profile/edit_password', to: 'users#update_password'

# end


Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'welcome#home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create' #change to login
  get '/logout', to: 'sessions#end' #change to logout

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
  get '/profile/orders', to: 'orders#index'

  post '/users', to: 'users#create'
  get '/register', to: 'users#new'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile/edit', to: 'users#update'
  get '/profile/edit_password', to: 'users#edit_password'
  patch '/profile/edit_password', to: 'users#update_password'
end
