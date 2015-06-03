Rails.application.routes.draw do

 namespace :users do

   # Registrstions
   # Sign up
   post  'registrations' => 'registrations#create'
   patch 'registrations' => 'registrations#update'

   #Sessions
   #Sign in
   post   'sessions' => 'sessions#create'
   delete 'sessions' => 'sessions#destroy'
   get    'sessions' => 'sessions#profile'

   #Password recovery
   #Request for recovery
   get 'password/new'  => 'passwords#new'
   get 'password/edit' => 'passwords#edit',   as: :password_recovery_form
   patch 'password'     => 'passwords#update', as: :change_password

 end

#  Credit Cards
 resources :credit_cards, only: [:create, :update, :destroy, :index]

 root 'home#index'


end

