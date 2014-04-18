# Provides the public interface for the api

require 'utapi/exceptions'
require 'utapi/login_service'
require 'utapi/account'

module UTApi
  class Client

    def self.encode_query_string(query_hash)
      query_hash.map { |key, value| "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}" }.join('&')
    end

    def initialize(email, password, hash, platform)

      @account = Account.new(email: email, password: password, hash: hash, platform: platform)

    end

    def login
      authorization
    rescue LoginError
      false
    else
      true
    end

    def search(params)

      action = 'transfermarket?' + self.class.encode_query_string(params)

      do_request(action).tap do |response|
        raise ApiCallFailed, "response has no auctionInfo: #{response}" unless response.is_a?(Hash) and response.has_key?('auctionInfo')
      end

    end

    def auction_status(ids)

      action = 'trade/status?' + self.class.encode_query_string(tradeIds: ids.join(','))

      do_request(action).tap do |response|
        raise ApiCallFailed, "response has no auctionInfo: #{response}" unless response.is_a?(Hash) and response.has_key?('auctionInfo')
      end

    end

    def bid(trade_id, value)

      do_request("trade/#{trade_id}/bid", :put, {bid: value}).tap do |response|
        raise ApiCallFailed, "Cannot bid, response: #{response}" unless response.is_a?(Hash) and response.has_key?('auctionInfo')
      end

    end


    def list_item(item_id, start_price, bin_price, duration)

      do_request('auctionhouse', :post, {
          startingBid: start_price,
          duration: duration,
          itemData: {
              id: item_id
          },
          buyNowPrice: bin_price
      }).tap do |response|
        raise ApiCallFailed, "Cannot list item: #{response}" unless response.is_a?(Hash) and response.has_key?('id')
      end
    end

    def move_card(item_id, pile)

      do_request('item', :put, {
          itemData: [{ id: item_id, pile: pile }]
      }).tap do |response|
        raise ApiCallFailed, "Cannot move card: #{response}" unless response.is_a?(Hash) and response.has_key?('itemData') and response['itemData'][0]['success']
      end

    end

    def trade_pile
      do_request('tradepile', :get).tap do |response|
        raise ApiCallFailed, "Cannot get trade pile, response: #{response}" unless response.is_a?(Hash) and response.has_key?('auctionInfo')
      end
    end

    def unassigned_items
      do_request('purchased/items', :get)
    end

    def delete_from_trade_pile(trade_id)
      do_request("trade/#{trade_id}", :delete)
    end

    def get_credits
      do_request('user/credits')['credits']
    end

  private

    def do_request(action, verb=:get, payload=nil)

      headers = {
          'Content-Type' => 'application/json',
          'X-HTTP-Method-Override' => verb.to_s.upcase,
          'X-UT-PHISHING-TOKEN' => authorization.phishing_token,
          'X-UT-SID' => authorization.sid
      }
      response = connection.post("#{authorization.server}/ut/game/fifa14/#{action}", payload, headers)

      response.env[:body]
    end

    def authorization
      @authorization ||= LoginService.new(connection, @account).execute
    end

    def connection
      @connection ||= Connection.new
    end

  end
end