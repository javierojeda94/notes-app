require 'rails_helper'
require 'jwt_authentication'

describe 'Authentication' do
  context 'Registered User' do
    let(:user) { FactoryGirl.create(:user) }
    it 'can sign in in the api' do
      user.save
      post '/login', params: {
        email: 'test@factory.com',
        password: 'Pa$$w0rd'
      }

      expect(response).to be_success

      token = JWTAuthentication.encode({ user_id: User.first.id })
      expect(json['auth_token']).to eq(token)
    end
  end

  context 'Non Registered User' do
    it 'can not sign in in the api' do
      post '/login', params: {
        email: 'test@factory.com',
        password: ''
      }

      expect(response).to be_unauthorized
    end
  end
end