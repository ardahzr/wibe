Rails.application.routes.draw do
  resources :friendships, only: [:create, :update, :destroy]
  resources :posts
  
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update]
  
  get 'profile', to: 'accounts#show', as: :profile
  root to: 'home#index'
end
