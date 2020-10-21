Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get ':resource/find', to: 'search#show'
      get ':resource/find_all', to: 'search#index'
      get 'merchants/most_revenue', to: 'revenue#index'
      get 'merchants/most_items', to: 'revenue#show'
      get '/revenue', to: 'totals#index'
      resources :merchants, except: [:new, :edit] do
        get '/items', to: 'relations#index'
        get '/revenue', to: 'totals#show'
      end
      resources :items, except: [:new, :edit] do
        get '/merchant', to: 'relations#show'
      end
    end
  end
end
