# frozen_string_literal: true

Devtools::Engine.routes.draw do
  root to: "dashboard#show"
  resources :dashboard, only: :show
  resources :image_assets, only: [:show, :index, :destroy]
  resources :database_tables, only: [:show, :index]
  resources :gems, only: [:show, :index]
  resources :routes, only: [:show, :index]
  namespace :routes do
    resources :route_path_inputs, only: :update
  end
end
