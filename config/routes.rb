# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'static_pages#homepage'

  devise_for :users,
             controllers: {
               confirmations: 'confirmations',
               registrations: 'registrations',
               sessions: 'sessions'
             }

  resources :comments, only: %i[edit create update destroy]
  resources :ratings, only: %i[create update]

  get 'hunts/:id/join/:token', to: 'hunts#join', as: :join_hunt
  post 'hunts/:id/join/:token', to: 'hunts#join', as: :join_accept_hunt

  resources :hunts, only: %i[create index show] do
    resources :homes do
      patch :restore, on: :member
    end
  end
end
