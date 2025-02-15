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
    resources :comments, only: [:create]
  end

  resources :messages, only: [:index, :new, :create, :show]
  resources :users, only: [:index, :show, :edit, :update]

  get 'profile', to: 'accounts#show', as: :profile
  get 'profile/posts/:id', to: 'accounts#show_post', as: :profile_post
  root to: 'home#index'
end
