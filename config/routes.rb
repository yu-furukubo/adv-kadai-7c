# frozen_string_literal: true

Rails.application.routes.draw do
  get 'groups/index'
  get 'groups/show'
  get 'groups/edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get "home/about"=>"homes#about"
  get "search"=>"searches#search", as: "search"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update, :follow_users] do
    member do
      get :follow_users, :follower_users
    end
    resource :relationship, only: [:create, :destroy]
  end
  resources :groups do
    get "join" => "groups#join"
    delete "out_of_group" => "groups#out_of_group"
  end

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
