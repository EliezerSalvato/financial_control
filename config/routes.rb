Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :groups
      resources :categories
      resources :cards
    end
  end

  match "*path", to: "home#index", via: :get
end
