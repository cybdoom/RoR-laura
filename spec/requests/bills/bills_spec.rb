require 'rails_helper'

describe 'Bills:', type: :request do
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
      last_name: 'Doe',
      address: 'Washington, 1st 1',
      driver_license: '12345678',
      license_plate_number: '98765432'
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

  context 'create new parking ticket' do
    let(:valid_parking_ticket) {
      {
        bill: {
          bill_type: :parking_ticket,
          status: :payed,
          payment_status: :payed,
          payed_amount: 123.45,
          payed_date: Date.today,
        }
      }
    }


    let(:invalid_parking_ticket) {
      {
        bill: {
          bill_type: :parking_ticket_err,
          payment_status: :payed,
          payed_amount: 123.45,
          payed_date: Date.today,
        }
      }
    }



    it 'with valid params' do
      post bills_path, valid_parking_ticket, authenticated_headers
      response_hash = JSON.parse(response.body)

      parking_ticket = valid_parking_ticket[:bill]
      expect(response.status).to eq(200)
      expect(response_hash['bill_status']).to eq(parking_ticket[:bill_status])
      expect(response_hash['driver_license']).to eq(valid_user_params[:driver_license])
      expect(response_hash['payed_amount']).to eq(parking_ticket[:payed_amount])
    end

    it 'with invalid params', :skip_reqres do
      post bills_path, invalid_parking_ticket, authenticated_headers
      response_hash = JSON.parse(response.body)

      parking_ticket = valid_parking_ticket[:bill]
      expect(response.status).to eq(422)

    end
  end

end
