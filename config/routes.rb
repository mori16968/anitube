Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users
  resources :posts do
    resource :comments, only: [:create, :destroy]
  end
  resources :favorites, only: [:create, :destroy]
  resources :users do
    get :follows, on: :member
    get :followers, on: :member
  end
  resources :relationships, only: [:create, :destroy]
  resources :notifications, only: :index
end
