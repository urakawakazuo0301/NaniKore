Rails.application.routes.draw do
  devise_for :users
  
  root 'items#index'
  resources :users, only: [:edit, :update]

  resources :items do
    resources :item_shares, only: [:create, :destroy]

    collection do
      get 'search'
      post 'upload_image'
    end
    
    member do
      patch 'mark_as_used'
      delete 'delete_image'
      post 'upload_image'
    end
  end

end
