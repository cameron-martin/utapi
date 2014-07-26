require 'spec_helper'

require 'utapi/login_service'
require 'utapi/connection'
require 'utapi/account'

describe UTApi::LoginService, vcr: { cassette_name: 'requests' } do

  let(:account) do
    UTApi::Account.new(
        email: ENV['TEST_ACCOUNT_EMAIL'],
        password: ENV['TEST_ACCOUNT_PASSWORD'],
        hash: ENV['TEST_ACCOUNT_HASH'],
        platform: ENV['TEST_ACCOUNT_PLATFORM']
    )
  end

  let(:login_service) { UTApi::LoginService.new(account) }

  describe '#execute' do
    it 'does not raise error' do
      expect { login_service.execute }.to_not raise_error
    end

    it 'returns Authorization instance' do
      expect(login_service.execute).to be_a(UTApi::Authorization)
    end
  end
end