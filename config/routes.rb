# frozen_string_literal: true

Rails.application.routes.draw do
  mount Friday::Engine, at: '/api/v2'

  namespace :api do
    namespace :v1 do
      resources :hosts
      resources :repos
      resources :apps
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
