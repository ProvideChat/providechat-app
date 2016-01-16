require 'api_constraints'

Rails.application.routes.draw do

  devise_for :admins
  devise_for :agents, path: 'auth', 
               controllers: {
                 registrations: "registrations",
                 confirmations: 'confirmations'
               }

  resources :after_signup, only: [:edit, :update]
  resources :contact_forms, only: [:new, :create]
  resources :support_forms, only: [:new, :create]

  resources :visitors
  resources :departments
  resources :chats, only: [:index, :show]
  resources :websites, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :agents, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :rapid_responses, only: [:index, :new, :edit, :create, :update, :destroy]

  resources :offline_forms, only: [:index, :edit, :update]
  resources :prechat_forms, only: [:index, :edit, :update]
  resources :chat_widgets, only: [:index, :edit, :update]
  resources :invitations, only: [:index, :edit, :update]
  resources :organizations, only: [:edit, :update]

  mount StripeEvent::Engine => '/stripe-events'
  resources :subscriptions, only: [:new, :create, :edit, :update, :destroy]

  root to: 'home#dashboard', via: :get

  delete 'signout', to: 'home#signout', as: 'signout'
  get 'monitor', to: 'home#monitor', as: 'monitor'
  get 'dashboard', to: 'home#dashboard', as: 'dashboard'
  get 'code', to: 'home#code', as: 'code'
  post 'send_code', to: 'home#send_code', as: 'send_code'

  get 'documentation/start', to: 'documentation#start', as: 'doc_start'
  get 'documentation/general', to: 'documentation#general', as: 'doc_general'
  get 'documentation/websites', to: 'documentation#websites', as: 'doc_websites'
  get 'documentation/monitor', to: 'documentation#monitor', as: 'doc_monitor'

  get 'terms-of-service', to: 'static_pages#terms', as: 'terms'
  get 'privacy-policy', to: 'static_pages#privacy', as: 'privacy'

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :agents, only: [:update, :show]
      resources :chat_monitor, only: [:index, :update]
      resources :widgets, only: [:index]
    end
  end

  # Sidekiq monitoring
  require 'sidekiq/web'
  authenticate :admin do
    mount Sidekiq::Web => 'sidekiq'
  end
end
