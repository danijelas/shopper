Rails.application.routes.draw do

  resources :lists do
    post 'item_undone/:item_id', action: :item_undone, on: :member, as: :item_undone
    post 'update_item/:item_id', action: :update_item, on: :member, as: :update_item
    get '/change_category', action: :change_category, on: :member, as: :change_category
    post 'save_item', on: :member
    delete 'delete_item', on: :member
    post 'create_item', action: :create_item, on: :member, as: :create_item
    # resources :items
  end

  devise_for :users

  post 'users/set_currency' => 'users#set_currency', as: :set_currency

  get '/reports' => 'reports#index', as: :reports
  get 'reports/chart_data' => 'reports#chart_data', as: :chart_data

  root 'home#index'
  # resources :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
