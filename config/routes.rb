Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'posts#index'
  get 'homes/top'
  get 'homes/about'
  get 'unsubscribe/:user_id' => 'homes#unsubscribe', as: 'confirm_unsubscribe'
  patch 'withdraw/:user_id' => 'homes#withdraw', as: 'withdraw_user'

  resources :posts, only: [:new, :index, :show, :edit, :create, :update, :destroy] do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    collection do
      get 'maps' => 'posts#maps', as: 'maps'
    end
  end

  resources :users, only: [:index, :show, :edit, :update] do
    resources :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end


  resources :notifications, only: [:index] do
    collection do
      delete :destroy_all
    end
  end

  resources :genres, only: [:index, :create, :edit, :update]


end