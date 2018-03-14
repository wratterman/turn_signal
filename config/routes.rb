Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/' => redirect("/api/v1/makes")
  namespace :api do
    namespace :v1 do
      resources :makes do
        resources :models do
          resources :vehicles
        end
        resources :vehicles, only: [:index, :show]
      end

      resources :models, only: [:index, :show] do
        resources :vehicles, only: [:index, :show]
      end
      resources :vehicles, only: [:index, :show]
    end
  end
end
