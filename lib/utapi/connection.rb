require 'faraday'
require 'faraday_middleware'
require 'faraday-cookie_jar'
require 'faraday-rate_limiter'
require 'faraday/error_handler'

module UTApi
  class Connection

    attr_writer :cookie_jar
    attr_writer :request_interval

    def initialize
      @user_agent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727)'
    end

    # TODO: Define a better interface for these function
    def get(*args, &block)
      connection.get(*args, &block)
    end

    def post(*args, &block)
      connection.post(*args, &block)
    end

    def cookie_jar
      @cookie_jar ||= HTTP::CookieJar.new
    end

    def request_interval
      @request_interval ||= 2
    end

  private

    def connection
      @connection ||= Faraday.new(ssl: {verify: false}, request: {timeout: 20, open_timeout: 20}, headers: { 'User-Agent' => @user_agent }) do |faraday|
        faraday.response :follow_redirects, limit: 5
        #faraday.response :raise_error # This catches generic http errors
        #faraday.request :retry, exceptions: [UTApi::ConnectionError, UTApi::ServerError], interval: 1, backoff_factor: 2, max: 3
        faraday.use :error_handler # This is custom error handling
        faraday.use :cookie_jar, jar: cookie_jar
        faraday.request :url_encoded
        faraday.request :json
        faraday.response :json, content_type: 'application/json'
        faraday.request :rate_limiter, interval: request_interval if request_interval > 0
        faraday.adapter  :net_http_persistent
      end
    end

  end
end