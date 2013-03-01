Vouch::Application.routes.draw do
  ActiveAdmin.routes(self)
  root to: 'landing#index'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :vouch_lists

  post '/businesses/:city/:name/details' => 'businesses#details', as: 'get_business_details'
end
