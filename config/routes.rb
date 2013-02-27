Vouch::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users

  root to: "users#index"

  resources :vouch_lists
end
