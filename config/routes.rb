Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users
  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resource :comments, only: [:create, :destroy]
  end
  resources :users do
    resource :relationships, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
  end
  resources :notifications, only: :index
end
