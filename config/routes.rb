Rails.application.routes.draw do


  devise_for :admins
  devise_for :agents, :path => 'auth'

  resources :departments, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :chats
  resources :websites, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :agents, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :rapid_responses, only: [:index, :new, :edit, :create, :update, :destroy]
  
  resources :offline_messages, only: [:edit, :update]
  resources :prechat_surveys, only: [:edit, :update]
  resources :chat_widgets, only: [:edit, :update]
  resources :organizations, only: [:edit, :update]
  
  root to: 'home#dashboard'
  
  get '/monitor', to: 'home#monitor', as: 'monitor'
  get '/dashboard', to: 'home#dashboard', as: 'dashboard'
  get '/code', to: 'home#code', as: 'code'
  get '/contact', to: 'home#contact', as: 'contact'
  
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
