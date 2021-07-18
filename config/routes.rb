# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :categories
      resources :tags
      resources :cards
      resources :expenses do
        collection do
          get :last_expense
        end
      end
      resources :incomes
      resources :home do
        collection do
          get :incomes
          get :expenses
        end
      end
    end
  end

  match '*path', to: 'home#index', via: :get
end
