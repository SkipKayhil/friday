# frozen_string_literal: true

Friday::Engine.routes.draw do
  resources :hosts
  resources :dependencies, only: :index
  get '/dependencies/:language/:name', to: 'dependencies#show', as: :dependency
  resources :projects
end
