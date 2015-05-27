require 'rails_helper'

RSpec.describe 'Request to root', type: :request do
  it 'Checking for root', :skip_reqres do
    get '/'
    expect(response.body).to include('Welcome to Laura API')
  end
end
