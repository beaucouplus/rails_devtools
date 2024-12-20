# frozen_string_literal: true

Devtools::Engine.routes.draw do
  root to: "database_tables#index"
  get "*path.js.map", to: proc { [204, {}, [""]] }

  resources :image_assets, only: [:show, :index, :destroy]
  resources :database_tables, only: [:show, :index]
  resources :gems, only: [:show, :index]

  resources :routes, only: [:show, :index]
  namespace :routes do
    resources :route_path_inputs, only: :update
  end

  namespace :frontend do
    get "modules/*path", to: "modules#show", format: :js, constraints: ->(request) { request.path.end_with?(".js") }
  end

  get "host_app_images/*path", as: :host_app_image, to: "host_app_images#show",
                               constraints: lambda { |request|
                                 request.path.end_with?(*Devtools::ImageAssets::ImageInfo::IMAGE_EXTENSIONS.to_a)
                               }
end
