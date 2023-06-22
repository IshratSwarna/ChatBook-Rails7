require 'sidekiq/web'
Rails.application.routes.draw do
  resources :chat_rooms do 
    resources :messages
  end
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
  root 'pages#home'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  get 'user/:id', to: 'users#show', as: 'user'
end
