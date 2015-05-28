require 'rails_helper'

RSpec.describe 'Register a new user', type: :request do

  let (:headers) {
    {
      'X-DEVICE-ID' => '1111111',
      'X-MOBILE-PLATFORM' => 'IOS',
      'X-APPLICATION-NAME' => 'Laura IOS App',
      'X-APPLICATION-VERSION' => '1',
      'X-DEVICE-TIME-ZONE' => '+1',
      'X-DEVICE-LOCALE' => 'en-us',
    }
  }

  let (:valid_user_params) {
    {
      email: 'user@gmail.com',
      user_id: 'user@gmail.com',
      phone: '111111111111',
      password: '123uu123',
      password_confirmation: '123uu123'
      
    }
  }

  it 'First step of registration' do

    post '/users/registrations/sign_up', {user: valid_user_params}, headers
    response_hash =  JSON.parse(response.body)

    token = response_hash['current_authentication_token']
    expect(token.keys.first).to eq(headers['X-DEVICE-ID'])
    expect(token.values.first.length).to  eq(32)
    expect(response_hash['email']).to eq(valid_user_params[:email])

  end

  

  context 'Registrations Errors' do
    
    it 'Password and password confirmation are different', :skip_reqres do
      user_params = {
        email: 'user@gmail.com',
        user_id: 'user@gmail.com',
        phone: '111111111111',
        password: '123uu123',
        password_confirmation: '123uu1231'
      }

      post '/users/registrations/sign_up', {user: user_params}, headers
      response_hash = JSON.parse(response.body)

      expect(response.status).to eq(422)
      err_msg = "doesn't match Password"
      expect(response_hash['password_confirmation']).to include(err_msg)
    end

    it 'Password length should be mor than 7 chars', :skip_reqres do
      user_params = {
        email: 'user@gmail.com',
        user_id: 'user@gmail.com',
        phone: '111111111111',
        password: '123uu',
        password_confirmation: '123uu'
      }

      post '/users/registrations/sign_up', {user: user_params}, headers    
      response_hash = JSON.parse(response.body)
      
      expect(response.status).to eq(422)
      err_msg = "is too short (minimum is 8 characters)"
      expect(response_hash['password']).to include(err_msg)
    end

  end #context


end
