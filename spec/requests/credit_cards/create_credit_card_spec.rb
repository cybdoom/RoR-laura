require 'rails_helper'

describe 'Creation of new credit card', type: :request do
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

  let(:cc_params) {
    {
      credit_card: {
        cc_number: 112233,
        month: 'Jan',
        year: 2014,
        cvv: 321,
        zipcode: 4321
      }
    }
  }
  before :each do
    User.delete_all
    user = User.create valid_user_params.update(devices: authenticated_device)
  end

  it 'with valid params' do
    post credit_cards_path, cc_params, authenticated_headers
    response_hash = JSON.parse(response.body)

    card = cc_params[:credit_card]
    expect(response_hash['year']).to  eq(card[:year])
    expect(response_hash['cvv']).to  eq(card[:cvv].to_s)
    expect(response_hash['cc_number']).to  eq(card[:cc_number])
  end
end
