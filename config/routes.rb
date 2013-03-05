Vouch::Application.routes.draw do
  ActiveAdmin.routes(self)
  root to: 'landing#index'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :vouch_lists
  resources :vouch_items, only: [:create, :update, :destroy]

  # City-specific routes
  get '/vouch_lists/new/:city/' => 'vouch_lists#new_by_city', as: 'new_vouch_list_city'

  # Internal API
  post '/businesses/:city/:name/details' => 'businesses#details', as: 'get_business_details'
  get  '/vouch_list_details/:id' => 'vouch_lists#details', as: 'get_vouch_list'
end
