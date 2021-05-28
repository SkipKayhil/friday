# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :hosts
      resources :repos
      resources :apps do
        post :dependencies, on: :member
      end
      resources :libraries
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'application#index'
end
