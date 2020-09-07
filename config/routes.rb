Rails.application.routes.draw do

  root 'users#home'
  # get 'sessions/new'

  # get 'users/new'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

end
