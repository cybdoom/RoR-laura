require 'rails_helper'

RSpec.describe 'User sessions:', type: :request do

  let (:headers) {
    {
      'X-DEVICE-ID'           => '1111111',
      'X-MOBILE-PLATFORM'     => 'IOS',
      'X-APPLICATION-NAME'    => 'Laura IOS App',
      'X-APPLICATION-VERSION' => '1',
      'X-DEVICE-TIME-ZONE'    => '+1',
      'X-DEVICE-LOCALE'       => 'en-us',
    }
  }
  
  let (:valid_user_params) {
    {
      email:                  'user@gmail.com',
      user_id:                'user@gmail.com',
      phone:                  '111111111111',
      password:               '123uu123',
      password_confirmation:  '123uu123'
    }
  }


  context 'user actions - ' do
    let(:token) {   "3f898544c32fe878e46e40e7186364a5"}

    let(:authenticated_headers) { 
      headers.update 'X-AUTHENTICATION' => token
    }

    let(:authenticated_device) { 
      {
        '1111111' => {
          platform: 'IOS',
          app_name: 'Laura IOS App',
          authentication_token: token
        }
      } 
    }

    before :each do
      User.delete_all
      user = User.create valid_user_params.update(devices: authenticated_device)
    end

    context 'sign out' do
      it 'a user with valid token' do
        delete '/users/sessions', nil, authenticated_headers
        response_hash =  JSON.parse(response.body)
        expect(response_hash['message']).to eq(I18n.t('user.notifications.sign_out'))
      end
    end #Sign out


    context 'user profile' do
      it 'get a user profile' do
        get '/users/sessions', {}, authenticated_headers

        response_hash =  JSON.parse(response.body)
        expect(response_hash['email']).to eq(valid_user_params[:email])
      end
    end #user profile

  end


  context 'Sign in' do
    
    before :each do
      User.delete_all
      User.create valid_user_params
    end

    context 'with phone' do
      it 'invalid', :skip_reqres do

        sign_in_params = { 
          auth_credentials: {
            phone:     '12231231231231231231',
            password:  valid_user_params[:password]
          }
        }

        post '/users/sessions', sign_in_params, headers
        response_hash =  JSON.parse(response.body)
        expect(response_hash['error']).to eq(I18n.t('user.errors.invalid_credentials'))
      end


      it 'valid' do

        sign_in_params = { 
          auth_credentials: {
            phone:     valid_user_params[:phone],
            password:  valid_user_params[:password]
          }
        }

        post '/users/sessions', sign_in_params, headers
        response_hash =  JSON.parse(response.body)

        expect(response_hash['email']).to eq(valid_user_params[:email])
      end
    end



    context 'with email' do
      it 'invalid', :skip_reqres do

        sign_in_params = { 
          auth_credentials: {
            email:     'invalid@email.com',
            password:  valid_user_params[:password]
          }
        }

        post '/users/sessions', sign_in_params, headers
        response_hash =  JSON.parse(response.body)
        expect(response_hash['error']).to eq(I18n.t('user.errors.invalid_credentials'))
      end


      it 'valid' do

        sign_in_params = { 
          auth_credentials: {
            email:     valid_user_params[:email],
            password:  valid_user_params[:password]
          }
        }

        post '/users/sessions', sign_in_params, headers
        response_hash =  JSON.parse(response.body)

        expect(response_hash['email']).to eq(valid_user_params[:email])
      end
    end

  end
  
end
