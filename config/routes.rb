require 'DomainConstraint.rb'
require 'resque/server'
require 'sidekiq/web'

Sgbrowserserver::Application.routes.draw do

  get "registration/new"

  get "registration/create"

  get "registration/confirm"

  get "user/show"

  get "scrape_checker/check"
  get "scrape_checker/sd_analysis"

  match "invites/:invite_code" => "website#homepage"
  match "i/:invite_code" => "website#homepage"
  match "api/v1/tracking/download_button_clicks" => "invites#download_button_clicks"


  mount Resque::Server.new, :at => "/resque"
  mount Sidekiq::Web, at: '/sidekiq'
  if Rails.env.development? 
    mount DailyReportMailer::Preview => 'mail_view'
  end

  namespace :analytics do 
    resources :invites, only: [:index]
    resources :real_installs, only: [:index]
    resources :users, only: [:show]
    resources :retailers
  end

  get "pages/privacy"
   get "pages/tfi_privacy"

  get "ext/show"
  get "ext/chrome"
  match "ext/safari" => "ext#show", :via => :get
  match "/safari" => "ext#show", :via => :get
  match "/chrome" => "ext#chrome", :via => :get

  get "supported_domains/index"

  get "visits/create"

  #define this before the /:identifiers path otherwise it will
  #override /admin
  
  #ActiveAdmin.routes(self)

  # data management namespace
  namespace :dm do
    resources :retailers do
      resources :full_items
      resources :retailer_colours
    end
    match "/categories" => "categories#choose", :as => :categories, via: [:get]
    match "/categories/:first_letter" => "categories#index"
    match "/categories" => "categories#update" ,via: [:put, :post]
  end

  #www.pickse.com
  constraints(DomainConstraint.new(['www', '','testwww','www.dev'])) do  
    match "/" => "website#homepage"
    match "/about" => "pages#about"
    get "/register" => "registrations#new", as: :new_registration
    post "/register" => "registrations#create", as: :create_registration
    get "/registration-complete" => "registrations#confirm", as: :confirm_registration
  end

  resources :viewed, :only => [:index]

  #me.pickse.com
  constraints(DomainConstraint.new(['testme', 'me','my','my.dev'])) do
    match "/" => "backbone_app#show"
    match "/:campaign_identifier" => "backbone_app#show"
    match "/items/:id" => "backbone_app#show"
  end

  # the pre-release backbone app
  constraints(DomainConstraint.new(['testbackbone', 'backbone'])) do
    match "/" => "backbone_app#show"
    match "/items/:id" => "backbone_app#show"
  end

  # the first version of the api used by the backbone app
  namespace :api do
    namespace :v1 do
      resources :items do 
        resources :likes, :only => [:create]
        resources :dislikes, :only => [:create]
      end

      resources :recommendations
      resources :history
      resources :top_items

    end
  end

  
  resources :visits
  resources :on_sale_items, :only => [:index]

  resources :user, :only => [] do
    resources :item , :only => [:create] do
      resources :likes, :only => [:create, :destroy]
      resources :dislikes, :only => [:create, :destroy]
      resources :ignores, :only => [:create, :destroy]
    end
  end

  resources :signups, :only => [:create]
  resources :messages, :only => [:create]
    devise_for :admin_users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => 'website#homepage'
end
