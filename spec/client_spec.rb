require 'spec_helper'

require 'utapi/client'

describe UTApi::Client, vcr: { cassette_name: 'requests' } do

  subject(:client) do
    UTApi::Client.new(
      ENV['TEST_ACCOUNT_EMAIL'],
      ENV['TEST_ACCOUNT_PASSWORD'],
      ENV['TEST_ACCOUNT_HASH'],
      ENV['TEST_ACCOUNT_PLATFORM']
    )
  end

  describe '#get_credits' do
    it 'should return credits' do
      response = client.get_credits

      expect(response['credits']).to be_kind_of(Integer)
    end
  end
end