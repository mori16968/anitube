Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  resources :posts do
    collection do
      get :feed
    end
    resources :comments, only: [:create, :destroy]
  end
  resources :favorites, only: [:create, :destroy]
  resources :users do
  end
  resources :relationships, only: [:create, :destroy]
  resources :notifications, only: :index
end
