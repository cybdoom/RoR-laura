Rails.application.routes.draw do

 namespace :users do
   
   # Registrstions
   # Sign up
   post  'registrations/sign_up' => 'registrations#sign_up'
   # Update profile 
   patch 'registrations' => 'registrations#update_profile'
 end

 root 'home#index'
    

end

