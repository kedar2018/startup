Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'pages#home'
  get 'pages/about'
  get 'pages/services'
  get 'pages/products'
  get "pages/product_detail/:id" , to: "pages#product_detail"
  get 'pages/team'
  get 'pages/price'
  get 'pages/contact'
  get 'pages/blog'
  get "pages/detail/:id", to: "pages#detail"
  get 'pages/feature'
  get 'pages/quote'
  get 'pages/service'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/testimonials", to: "pages#testimonials"
  post "request_quote", to: "request_quotes#create"
 post "/contact", to: "contacts#create"   # optional short alias
  # Defines the root path route ("/")
  # root "posts#index"
end
