Rails.application.routes.draw do
  get 'users/show'
  resources :chat_rooms do 
    resources :messages
  end
  root 'pages#home'
  devise_for :users

  get 'user/:id', to: 'users#show', as: 'user'
end
