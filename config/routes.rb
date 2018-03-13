Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get "/makes", to: 'makes#index'
      get "/makes/:id", to: 'makes#show'
    end
  end
end
