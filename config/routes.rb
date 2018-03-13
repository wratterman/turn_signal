Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get "/makes", to: 'makes#index'
      get "/makes/:id", to: 'makes#show'
      post "/makes", to: 'makes#create'
      put "/makes/:id", to: 'makes#update'
      delete "/makes/:id", to: 'makes#destroy'
    end
  end
end
