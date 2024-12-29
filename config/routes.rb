Rails.application.routes.draw do
  resources :messages do
    delete :delete, on: :member
  end
  resources :friendships, only: [:create, :update, :destroy]
  devise_for :users

  resources :posts do
    member do
      post 'like'  
      delete 'unlike' 
    end
  end

 

  resources :messages, only: [:index, :new, :create, :show]
  resources :users, only: [:index, :show, :edit, :update]

  get 'profile', to: 'accounts#show', as: :profile
  root to: 'home#index'
end
