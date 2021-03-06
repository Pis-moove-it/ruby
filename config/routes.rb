Rails.application.routes.draw do
  resources :organizations, only: [] do
    member do
      post :amount_recycled_by_month
    end
    collection do
      post :login
    end
    resources :users, only: %i[index show] do
      member do
        post :login
      end
    end
  end

  resources :pockets, only: [:index] do
    member do
      put :edit_serial_number
      put :edit_weight
      put :add_weight
    end
  end

  resources :routes, only: %i[create update show index] do
    resources :collections, only: %i[create]
    resources :events, only: %i[create]
  end

  resources :bales, only: %i[index create show update]

  resources :containers, only: %i[index show update]

  resources :collection_points, only: %i[create] do
    collection do
      delete :destroy
      put :update
    end
  end

  resources :questions, only: %i[index]

  resources :classification, only: %i[create]

  mount SwaggerUiEngine::Engine, at: '/api_docs'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
