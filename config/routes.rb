require 'api_constraints'

Rails.application.routes.draw do

  devise_for :agents, path: 'auth', 
               controllers: {
                 registrations: "registrations",
                 confirmations: 'confirmations'
               }

  mount RailsAdmin::Engine => '/manage', as: 'rails_admin'
  devise_for :admins, path: 'admin'

  resources :after_signup, only: [:edit, :update]
  resources :contact_forms, only: [:new, :create]
  resources :support_forms, only: [:new, :create]

  resources :visitors
  resources :departments
  resources :chats, only: [:index, :show]
  resources :websites, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :agents, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :rapid_responses, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :settings, only: [:update]

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

  post 'send_code', to: 'send_code#show', as: 'send_code'
  post "add_ftp_server", to: "after_signup#add_ftp_server", as: "add_ftp_server"

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
  #authenticate :admin do
    mount Sidekiq::Web => 'sidekiq'
  #end

  get "/404" => "errors#not_found"
  get "/500" => "errors#internal_server_error"
end
