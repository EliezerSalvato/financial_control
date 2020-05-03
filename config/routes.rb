Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :groups
    end
  end

  match "*path", to: "home#index", via: :get
end
