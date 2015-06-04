require 'rails_helper'

RSpec.describe 'Register a new user', type: :request do

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


  context 'First step' do
    it 'First step' do
      post '/users/registrations', { user: valid_user_params }, headers
      response_hash =  JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response_hash['email']).to eq(valid_user_params[:email])
      expect(response_hash['authentication_token'].length).to eq(32)
    end

    it 'invalid headers sent', :skip_reqres do
      post '/users/registrations', { user: valid_user_params }
      response_hash =  JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(response_hash['error']).to eq(I18n.t('user.errors.invalid_headers'))
    end
  end

  context 'Second step' do
    let(:authenticated_headers) {
      headers.update 'X-AUTHENTICATION' => "3f898544c32fe878e46e40e7186364a5"
    }

    let(:authenticated_device) {
      {
        '1111111' => {
          platform: 'IOS',
          app_name: 'Laura IOS App',
          authentication_token: "3f898544c32fe878e46e40e7186364a5"
        }
      }
    }

    it 'Second step' do
      User.delete_all
      user = User.create valid_user_params.update(devices: authenticated_device)

      profile_params = {
        user: {
          first_name:           'John',
          middle_name:          'Simon',
          last_name:            'Smith',
          license_plate_number: '1'*10,
          license_plate_state:  'active',
          driver_license:       'some_driver_license_id',
          driver_license_state: 'driver_license_state_id',
          state:                'Washington',
          address:              'somewhere str, 1',
        }
      }

      patch '/users/registrations', profile_params, authenticated_headers

      response_hash = JSON.parse(response.body)
      expect(response_hash['first_name']).to  eq('John')
      expect(response_hash['state']).to       eq('Washington')

      User.delete_all
    end
  end



  context 'Registrations Errors' do

    it 'Password and password confirmation are different', :skip_reqres do
      user_params = {
        email:                 'user@gmail.com',
        user_id:               'user@gmail.com',
        phone:                 '111111111111',
        password:              '123uu123',
        password_confirmation: '123uu1231'
      }

      post '/users/registrations', {user: user_params}, headers
      response_hash = JSON.parse(response.body)

      expect(response.status).to eq(422)
      err_msg = "doesn't match Password"
      expect(response_hash['error']).to include(err_msg)
    end

    it 'Password length should be mor than 7 chars', :skip_reqres do
      user_params = {
        email:                  'user@gmail.com',
        user_id:                'user@gmail.com',
        phone:                  '111111111111',
        password:               '123uu',
        password_confirmation:  '123uu'
      }

      post '/users/registrations', {user: user_params}, headers
      response_hash = JSON.parse(response.body)

      expect(response.status).to eq(422)
      err_msg = "is too short (minimum is 8 characters)"

      expect(response_hash['error']).to include(err_msg)
    end

  end #context


end
