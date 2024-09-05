Rails.application.routes.draw do
  devise_for :users
  root 'items#index'
  resources :users, only: [:edit, :update]
  resources :items, only: [:new, :create]
end
