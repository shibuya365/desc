Rails.application.routes.draw do

  root 'posts#home'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :posts do
    member do
      patch :append
    end
  end

end
