require 'rails_helper'

describe 'Credit card', type: :request do
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
  let(:cc_params_other) {
    {
      credit_card: {
        cc_number: 554433,
        month: 'Dec',
        year: 2015,
        cvv: 987,
        zipcode: 7733
      }
    }
  }
  let(:invalid_cc_params) {
    {
      credit_card: {
        month: 'Jan',
        cvv: 321,
        zipcode: 4321,
        cc_number: ''
      }
    }
  }

  before :each do
    User.delete_all
    user = User.create valid_user_params.update(devices: authenticated_device)
  end

  context 'update existing ' do
    before :each do
      User.first.credit_cards.create cc_params[:credit_card]
    end

    let(:credit_card) { User.first.credit_cards.first }


    it 'with valid params' do
      patch credit_card_path(credit_card.id), cc_params_other, authenticated_headers
      response_hash = JSON.parse(response.body)

      card = cc_params_other[:credit_card]
      expect(response_hash['year']).to  eq(card[:year])
      expect(response_hash['cvv']).to  eq(card[:cvv].to_s)
      expect(response_hash['cc_number']).to  eq(card[:cc_number])
    end

    it 'unexisting card', :skip_reqres do
      patch credit_card_path(232323), invalid_cc_params, authenticated_headers
      response_hash = JSON.parse(response.body)

      expect(response.status).to eq(404)
    end

    it 'with invalid params', :skip_reqres do
      patch credit_card_path(credit_card.id), invalid_cc_params, authenticated_headers
      response_hash = JSON.parse(response.body)

      expect(response.status).to eq(422)
    end
  end


  context 'create new ' do
    it 'with valid params' do
      post credit_cards_path, cc_params, authenticated_headers
      response_hash = JSON.parse(response.body)

      card = cc_params[:credit_card]
      expect(response_hash['year']).to  eq(card[:year])
      expect(response_hash['cvv']).to  eq(card[:cvv].to_s)
      expect(response_hash['cc_number']).to  eq(card[:cc_number])
    end

    it 'with invalid params', :skip_reqres do
      post credit_cards_path, invalid_cc_params, authenticated_headers
      response_hash = JSON.parse(response.body)
      card = cc_params[:credit_card]
      expect(response.status).to eq(422)
    end
  end

end
