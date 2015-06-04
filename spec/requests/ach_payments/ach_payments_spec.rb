require 'rails_helper'

describe 'ACH Payment:', type: :request do
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
      password_confirmation:  '123uu123',
      first_name: 'John',
      middle_name: 'C.',
      last_name: 'Doe'
    }
  }

  let(:token) {"3f898544c32fe878e46e40e7186364a5"}
  let(:authenticated_headers) { headers.update 'X-AUTHENTICATION' => token }

  let(:authenticated_device) {
    {
      '1111111' => {
        platform: 'IOS',
        app_name: 'Laura IOS App',
        authentication_token: token
      }
    }
  }

  let(:valid_ach_payment_params) {
    {
      ach_payment: {
        account_nr: '12345678'.reverse,
        routing_nr: '12345678',
        first_name: valid_user_params[:first_name],
        middle_name: valid_user_params[:middle_name],
        last_name: valid_user_params[:last_name],
      }
    }
  }

  let(:invalid_ach_payment_params) {
    {
      ach_payment: {
        routing_nr: '12345678'*300
      }
    }
  }

  before :each do
    User.delete_all
    user = User.create valid_user_params.update(devices: authenticated_device)
  end

  context 'create new' do
    it 'with valid params' do
      post ach_payments_path, valid_ach_payment_params, authenticated_headers
      response_hash = JSON.parse(response.body)

      ach_payment = valid_ach_payment_params[:ach_payment]
      expect(response.status).to eq(200)
      expect(response_hash['routing_nr']).to eq(ach_payment[:routing_nr])
      expect(response_hash['address']).to eq(valid_user_params[:address])
      expect(response_hash['first_name']).to eq(valid_user_params[:first_name])

    end

    it 'with invalid params', :skip_reqres do
      post ach_payments_path, invalid_ach_payment_params, authenticated_headers
      response_hash = JSON.parse(response.body)

      ach_payment = valid_ach_payment_params[:ach_payment]
      expect(response.status).to eq(422)

    end
  end

end
