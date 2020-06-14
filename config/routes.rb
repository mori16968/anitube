Rails.application.routes.draw do

  get 'comments/create'
  get 'comments/destroy'
  root 'posts#index'
  devise_for :users
  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resource :comments, only: [:create, :destroy]
  end
  resources :users
end
