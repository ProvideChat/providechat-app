require 'api_constraints'

Rails.application.routes.draw do

  devise_for :admins
  devise_for :agents, :path => 'auth', :controllers => {:registrations => "registrations"}

  resources :visitors
  resources :departments, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :chats, only: [:index, :show]
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
end
