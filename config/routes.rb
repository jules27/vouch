Vouch::Application.routes.draw do
  ActiveAdmin.routes(self)
  root to: "landing#index"

  devise_for :users
  resources :vouch_lists
end
