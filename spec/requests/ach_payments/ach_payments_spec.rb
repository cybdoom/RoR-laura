require 'rails_helper'

describe 'ACH Payment:', type: :request do

  let(:token) {"3f898544c32fe878e46e40e7186364a5"}
  let(:authenticated_headers) { LauraSpecHelper.ios_device.update 'X-AUTHENTICATION' => token }

  let(:authenticated_device) {
    {
      '1111111' => {
        platform: 'IOS',
        app_name: 'Laura IOS App',
        authentication_token: token
      }
    }
  }

  let(:valid_user_params) {
    LauraSpecHelper.valid_user_params.update(devices: authenticated_device).
      merge(LauraSpecHelper.valid_user_profile[:user].
      slice(:first_name, :last_name, :middle_name))
  }

  let(:another_valid_ach_payment_params) {
    {
      ach_payment: {
        account_nr: CreditCardValidations::Factory.random(:amex),
        routing_nr: '4433555',
        first_name:  valid_user_params[:first_name],
        middle_name: valid_user_params[:middle_name],
        last_name:   valid_user_params[:last_name],
      }
    }
  }

  let(:valid_ach_payment_params) {
    {
      ach_payment: {
        account_nr: CreditCardValidations::Factory.random(:visa),
        routing_nr: '12345678',
        first_name:  valid_user_params[:first_name],
        middle_name: valid_user_params[:middle_name],
        last_name:   valid_user_params[:last_name],
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
    @user = User.create valid_user_params
  end

  context 'List' do
    before :each do
      @user.ach_payments.create another_valid_ach_payment_params[:ach_payment]
      @user.ach_payments.create valid_ach_payment_params[:ach_payment]
    end

    it 'get list' do
      get ach_payments_path, {}, authenticated_headers
      response_hash =  JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(response_hash.length).to eq(2)
    end
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
