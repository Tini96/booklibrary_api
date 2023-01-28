Rails.application.routes.draw do
  resources :user_type, only: [:index]

  post '/auth/login', to: 'authentication#login'

  get '/users', to: 'users#index'
  post '/register', to: 'users#create', as: 'register'
  delete '/profile', to: 'users#destroy'
  put '/profile', to: 'users#update'
  get '/profile', to: 'users#show'

  resources :books

  
end
