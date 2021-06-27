Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :categories
      resources :tags
      resources :cards
      resources :expenses
      resources :incomes
      resources :dashboard do
        collection do
          get :incomes
          get :expenses
        end
      end
    end
  end

  match "*path", to: "home#index", via: :get
end
