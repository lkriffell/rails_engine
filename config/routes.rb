Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, except: [:new, :edit] do
        get '/items', to: 'relations#index'
      end
      resources :items, except: [:new, :edit] do
        get '/merchant', to: 'relations#show'
      end
      get ':resource/find', to: 'search#show'
      get ':resource/find_all', to: 'search#index'
    end
  end
end
