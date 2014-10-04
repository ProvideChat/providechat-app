require 'api_constraints'

Rails.application.routes.draw do

  devise_for :admins
  devise_for :agents, :path => 'auth', :controllers => {:registrations => "registrations"}

  resources :visitors
  resources :departments, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :chats
  resources :websites, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :agents, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :rapid_responses, only: [:index, :new, :edit, :create, :update, :destroy]

  resources :widgets, only: [:index]

  resources :offline_forms, only: [:index, :edit, :update]
  resources :prechat_forms, only: [:index, :edit, :update]
  resources :chat_widgets, only: [:index, :edit, :update]
  resources :invitations, only: [:index, :edit, :update]
  resources :organizations, only: [:edit, :update]

  root to: 'home#dashboard', via: :get

  get '/monitor', to: 'home#monitor', as: 'monitor'
  get '/dashboard', to: 'home#dashboard', as: 'dashboard'
  get '/code', to: 'home#code', as: 'code'
  get '/contact', to: 'home#contact', as: 'contact'

  get 'documentation/start', to: 'documentation#start', as: 'doc_start'
  get 'documentation/general', to: 'documentation#general', as: 'doc_general'
  get 'documentation/websites', to: 'documentation#websites', as: 'doc_websites'
  get 'documentation/monitor', to: 'documentation#monitor', as: 'doc_monitor'

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :agents, only: [:update]
      resources :chat_monitor, only: [:index, :update]
    end
  end

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
