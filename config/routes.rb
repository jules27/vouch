Vouch::Application.routes.draw do
  ActiveAdmin.routes(self)
  root to: 'landing#index'

  devise_for :users

  # Facebook login
  # match 'auth/:provider/callback', to: 'sessions#create'
  # match 'auth/failure', to: redirect('/')
  # match 'signout', to: 'sessions#destroy', as: 'signout'

  resources :vouch_lists
end
