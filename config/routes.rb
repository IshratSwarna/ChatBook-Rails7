Rails.application.routes.draw do
  get 'archived_notifications', to: 'chat_rooms#archived_notifications'
  resources :chat_rooms do 
    resources :messages
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root 'pages#home'
  #FOR WEB
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'user/:id', to: 'users#show', as: 'user'
  #FOR API 
  namespace :api do
    namespace :v1 do
      get '/chat_rooms', to: 'chat_rooms#index'
      get '/current_user', to: 'current_user#index'
      devise_for :users, controllers: {
        sessions: 'api/v1/users/sessions',
        registrations: 'api/v1/users/registrations'
      }
    end
  end
end
