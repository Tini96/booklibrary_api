Rails.application.routes.draw do
  resources :user_type, only: [:index]

  post '/auth/login', to: 'authentication#login'

  post '/register', to: 'users#create', as: 'register'
  resources :users, param: :username, only: [:index, :destroy, :update, :show]

  resources :books
  resources :authors
  resources :loans

  get '/out-of-stock', to: 'books#out_of_stock'

  
end
