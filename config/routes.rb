Zombies::Application.routes.draw do
  resources :items  do
    member do
      get :show
      patch :pickup
      patch :use
    end
  end

  resources :zombie_masters do
    resources :floor_plans, module: 'zombie_masters' do
      resources :tags, module: 'floor_plans' do
        member do
          get :assign
        end
      end
    end
    member do
      get :assume
    end
  end

  resources :players do 
    collection do
      get "tick"
      get "infectshow"
      post "infect"
    end
    member do
      get 'assume'
      get 'arrive_at_base'
    end
  end

  resources :commanders do
    member do
      get :assume
      post :message
      post :broadcast
    end
  end

  resources :base do
    member do
      get :index
      post :items
    end
  end

  get 'dash' => 'player_dashboard#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'application#index'

  post 'api/bluetooth/:id' => 'api#bluetooth'
  get 'api/bluetooth/:id' => 'api#bluetooth'
  post 'api/tag/:id' => 'api#tag'
  get 'api/tag/:id' => 'api#tag'
  get 'api/base' => 'api#base'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
