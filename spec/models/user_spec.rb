require 'rails_helper'

RSpec.describe User, type: :model do

  it 'test 1' do
    user = User.create email: 'some@gmail.com', password: '1'*8, 
      password_confirmation: '1'*4

    expect(User.all.count).to eq(0)
  end
  context 'message' do
    
    it 'create new user' do
      user = User.create email: 'some@gmail.com', password: '1'*8, 
        password_confirmation: '1'*8

      expect(User.all.count).to eq(1)
    end
  end


end
