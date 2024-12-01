Rails.application.routes.draw do
  get "home/index"
  get "users/show"
  get "users/edit"
  devise_for :users
  resources :users, only: [:show, :edit, :update]
  root to: 'home#index'
end
