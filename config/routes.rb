Rails.application.routes.draw do
  get 'archived_notifications', to: 'chat_rooms#archived_notifications'
  resources :chat_rooms do 
    resources :messages
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root 'pages#home'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'user/:id', to: 'users#show', as: 'user'
end
