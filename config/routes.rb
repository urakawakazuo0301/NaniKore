Rails.application.routes.draw do
  devise_for :users
  
  root 'items#index'
  resources :users, only: [:edit, :update]
  resources :items, only: [:new, :create, :update] do
    collection do
      get 'search'
    end
  end
  
  post "items/upload_image", to: "items#upload_image"

end
