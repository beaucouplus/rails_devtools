Rails.application.routes.draw do
  mount Devtools::Engine => "/devtools"

  resources :posts, only: [:index, :show]
  get "something_else", to: "something_else#show"

  get "redirect", to: redirect("/something_else")
  get "inline", to: ->(_env) { [200, {}, ["Hello, World!"]] }
  match "everything", to: "everything#show", via: :all
end
