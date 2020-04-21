Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  match "*path", to: "home#index", via: :get
end
