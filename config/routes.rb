Rails.application.routes.draw do
  devise_for :users
  
  root 'items#index'
  resources :users, only: [:edit, :update]
  resources :items do
    collection do
      get 'search'
    end
    member do
      patch 'mark_as_used'
      delete 'delete_image'
    end
  end
  
  post "items/upload_image", to: "items#upload_image"

end
