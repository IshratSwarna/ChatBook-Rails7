Rails.application.routes.draw do
  resources :chat_rooms do 
    resources :messages
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root 'pages#home'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  get 'user/:id', to: 'users#show', as: 'user'
end
