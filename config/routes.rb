Vouch::Application.routes.draw do
  ActiveAdmin.routes(self)
  root to: 'landing#index'

  devise_for :users, :controllers => {:registrations => "registrations"}
  # devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :vouch_lists, except: [:new]
  resources :vouch_items, only: [:create, :update, :destroy]

  # Business related
  resources :businesses, only: [:create]
  get  '/businesses/new/:type' => 'businesses#new_by_type', as: 'new_business_by_type'

  # City-specific routes
  get  '/vouch_lists/new/:city/' => 'vouch_lists#new_by_city', as: 'new_vouch_list_city'

  # Get more info about a model
  post '/businesses/:city/:name/details' => 'businesses#details', as: 'get_business_details'
  get  '/vouch_list_details/:id' => 'vouch_lists#details', as: 'get_vouch_list'

  # Shared friends
  get    '/vouch_lists/:id/get_shared_friends' => 'vouch_lists#get_shared_friends'
  post   '/vouch_lists/:id/add_shared_friend'  => 'vouch_lists#add_shared_friend'
  delete '/shared_friends/:id' => 'shared_friends#destroy'

  # After google oauth
  get  '/oauth2callback'   => "landing#oauth2callback"
  post '/vouch_lists/auth' => "vouch_lists#show_with_token", as: 'vouch_list_with_token'

  # For mailer to share vouch lists
  post '/vouch_lists/share_email/:id' => "vouch_lists#share_email", as: 'share_vouch_list'

  # Item tags
  get    '/vouch_items/:id/get_tagging'    => "vouch_items#get_tagging"
  post   '/vouch_items/:id/add_tagging'    => "vouch_items#add_tagging"
  delete '/vouch_items/:id/delete_tagging' => "vouch_items#delete_tagging"

  resources :friendships, only: [:index, :create, :update, :destroy]

  # Friends/ friendships
  get  '/friends' => "friends#index", as: 'friends'
  post '/friendships/add' => "friendships#add"
end
