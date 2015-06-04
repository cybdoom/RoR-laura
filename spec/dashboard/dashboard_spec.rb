require 'rails_helper'

describe 'Dashboard:', type: :request do
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

  before :each do
    User.delete_all
    user = User.create valid_user_params.update(devices: authenticated_device)
  end

  context 'current' do
    it 'with valid params' do
      get root_path, {}, authenticated_headers
      response_hash = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(response_hash['news_from_ward47'].count).to eq(4)
      expect(response_hash['news_from_mayer'].count).to eq(4)
      expect(response_hash['payment_alert'].count).to eq(2)
    end
  end

end