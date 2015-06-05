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

  let(:valid_water_bill) {
    {
      bill: {
        bill_type: :water_bill,
        status: :unpayed,
        payment_status: :due_soon,
        payed_amount: 123.45,
        payed_date: Date.today,
      }
    }
  }


  before :each do
    User.delete_all
    @user = User.create valid_user_params.update(devices: authenticated_device)
  end

  context 'lists of' do
    before :each do
      [:payed, :unpayed].each do |e|
        @user.bills.create valid_parking_ticket[:bill].update(status: e)
        @user.bills.create valid_water_bill[:bill].update(status: e)
      end
    end

    context 'Parking tickets' do
      it 'get list' do
        get bills_path, {bill_type: :parking_ticket}, authenticated_headers
        response_hash = JSON.parse(response.body)
        expect(response_hash.length).to eq(2)
      end
    end

    context 'water bills' do
      it 'get list' do
        get bills_path, {bill_type: :water_bill}, authenticated_headers
        response_hash = JSON.parse(response.body)
        expect(response_hash.length).to eq(2)
      end
    end

    context 'payed bills' do
      it 'get list' do
        get bills_path, {status: :payed}, authenticated_headers
        response_hash = JSON.parse(response.body)
        expect(response_hash.length).to eq(2)
      end
    end

    context 'unpayed bills' do
      it 'get list' do
        get bills_path, {status: :unpayed}, authenticated_headers
        response_hash = JSON.parse(response.body)
        expect(response_hash.length).to eq(2)
      end
    end
  end

  context 'all bills' do

    it 'get list' do
      @user.bills.create valid_parking_ticket[:bill]
      @user.bills.create valid_water_bill[:bill]

      get bills_path, {}, authenticated_headers
      response_hash = JSON.parse(response.body)
      expect(response_hash.length).to eq(2)
    end
  end

  context 'create new water bill' do

    let(:invalid_water_bill) {
      {
        bill: {
          bill_type: :water_bill,
          payment_status: :payed,
          payed_amount: 'asd',
          payed_date: Date.today,
        }
      }
    }


    it 'with valid params' do
      post bills_path, valid_water_bill, authenticated_headers
      response_hash = JSON.parse(response.body)

      water_bill = valid_water_bill[:bill]
      expect(response.status).to eq(200)
      expect(response_hash['bill_status']).to eq(water_bill[:bill_status])
      expect(response_hash['driver_license']).to eq(valid_user_params[:driver_license])
      expect(response_hash['payed_amount']).to eq(water_bill[:payed_amount])
    end

    it 'with invalid params', :skip_reqres do
      post bills_path, invalid_water_bill, authenticated_headers
      response_hash = JSON.parse(response.body)

      expect(response.status).to eq(422)

    end
  end

  context 'create new parking ticket' do

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

      expect(response.status).to eq(422)

    end
  end

end
