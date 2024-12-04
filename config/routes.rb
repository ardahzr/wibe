Rails.application.routes.draw do
  resources :messages
  resources :friendships, only: [:create, :update, :destroy]
  devise_for :users
  resources :posts
  resources :users, only: [:index, :show, :edit, :update]
  resources :users, only: [:show, :edit, :update]
  get 'profile', to: 'accounts#show', as: :profile
  root to: 'home#index'
end
