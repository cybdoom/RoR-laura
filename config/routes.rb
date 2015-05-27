Rails.application.routes.draw do

 namespace :users do
   
   # Registrstions
   # Sign up
   post 'registrations/sign_up' => 'registrations#sign_up'

 end

 root 'home#index'
    

end

