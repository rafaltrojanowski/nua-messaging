Rails.application.routes.draw do

  root :to => 'messages#index'

  resources :messages
  resources :prescriptions, only: :create

end
