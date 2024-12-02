Rails.application.routes.draw do
  devise_for :users
  resources :messages, only: [:index, :new, :create, :show]
  resources :posts
  get "posts/index"
  get "posts/show"
  get "posts/new"
  get "posts/create"
  get "home/index"
  get "users/show"
  get "users/edit"
  resources :users, only: [:show, :edit, :update]
  get 'profile', to: 'accounts#show', as: :profile
  root to: 'home#index'
end
