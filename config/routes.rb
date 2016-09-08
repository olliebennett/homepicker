Rails.application.routes.draw do
  devise_for :users
  root to: 'static_pages#home'

  resources :comments
  resources :homes
end
