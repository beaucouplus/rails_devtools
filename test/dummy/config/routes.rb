Rails.application.routes.draw do
  mount Devtools::Engine => "/devtools"
end
