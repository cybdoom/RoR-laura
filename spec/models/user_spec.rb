require 'rails_helper'

RSpec.describe User, type: :model do

  context 'Password' do

    it 'User shouldn"t be valid with password lt 8 chars' do
      user = User.new password: '1'*5, password_confirmation: '1'*5
      err_msg = 'is too short (minimum is 8 characters)'
      user.valid?
      expect(user.errors.messages[:password]).to include(err_msg)
    end
    
    it 'User should be valid with password lt 8 chars' do
      user = User.new password: '1'*8, password_confirmation: '1'*8
      user.valid?
      err_msg = 'is too short (minimum is 8 characters)'
      expect(user.errors.messages[:password]).to be nil
    end
  end


  it 'Valid user should be created' do
    
    User.create  email: 'some@gmail.com',
                 password: '1'*8, 
                 password_confirmation: '1'*8,
                 phone: '1'*10,
                 user_id: 'some_user_id'

    expect(User.all.count).to eq(1)
  end


end
