require 'spec_helper'

require 'utapi/login_service'
require 'utapi/connection'
require 'utapi/account'

#require 'net-http-spy'
#
#Net::HTTP.http_logger = Logger.new(File.expand_path("../tmp/logs/login-#{Time.now}.log", File.dirname(__FILE__)))
#Net::HTTP.http_logger_options = { verbose: true }

describe UTApi::LoginService, vcr: { cassette_name: 'login' } do

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