require 'rails_helper'
RSpec.describe 'Password recovery', type: :request do

  let (:valid_user_params) {
    {
      email:                  'user@gmail.com',
      user_id:                'user@gmail.com',
      phone:                  '111111111111',
      password:               '123uu123',
      password_confirmation:  '123uu123'
    }
  }


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
  let(:user) { User.create valid_user_params }
  
  it 'request for recovery with invalid email', :skip_reqres do
    get '/users/password/new', { email: 'invalid@email.com'}, headers
    
    response_hash =  JSON.parse(response.body)
    
    msg = I18n.t('user.errors.user_not_found')
    expect(response.status).to eq(404)
    expect(response_hash['error']).to eq(msg)
  end
  
  it 'request for recovery' do
    get '/users/password/new', { email: user.email}, headers
    
    response_hash =  JSON.parse(response.body)
    
    msg = I18n.t('user.notifications.password.instructions_sent')
    expect(response_hash['message']).to eq(msg)
  end
end
