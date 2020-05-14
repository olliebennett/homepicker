Rails.application.routes.draw do
  root to: 'static_pages#homepage'

  devise_for :users,
             controllers: {
               confirmations: 'confirmations',
               registrations: 'registrations',
               sessions: 'sessions'
             }

  resources :comments

  resources :hunts do
    resources :homes do
      patch :restore, on: :member
    end
  end

  resources :images
end
