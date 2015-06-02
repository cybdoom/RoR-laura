Rails.application.routes.draw do

 namespace :users do

   # Registrstions
   # Sign up
   post  'registrations' => 'registrations#create'
   # Update profile 
   patch 'registrations' => 'registrations#update'

   #Sessions
   #Sign in
   post   'sessions' => 'sessions#create'
   delete 'sessions' => 'sessions#destroy'
   get    'sessions' => 'sessions#profile'

   #Password recovery
   #Request for recovery
   get 'password/new' => 'passwords#new'
 end

 root 'home#index'
    

end

