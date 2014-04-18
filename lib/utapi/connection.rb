require 'faraday'
require 'faraday_middleware'
require 'faraday-cookie_jar'
require 'faraday-rate_limiter'
require 'faraday/error_handler'

module UTApi
  class Connection
    def initialize(cookie_jar=HTTP::CookieJar.new, logger=nil)
      @cookie_jar = cookie_jar
      @logger = logger
      @user_agent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727)'
      @conn = create_connection
    end

    # TODO: Define a better interface for these function
    def get(*args, &block)
      @conn.get(*args, &block)
    end

    def post(*args, &block)
      @conn.post(*args, &block)
    end

  private

    def create_connection
      Faraday.new(ssl: {verify: false}, request: {timeout: 20, open_timeout: 20}, headers: { 'User-Agent' => @user_agent }) do |faraday|
        faraday.response :follow_redirects, limit: 5
        #faraday.response :raise_error # This catches generic http errors
        #faraday.request :retry, exceptions: [UTApi::ConnectionError, UTApi::ServerError], interval: 1, backoff_factor: 2, max: 3
        faraday.use :error_handler # This is custom error handling
        faraday.use :cookie_jar, jar: @cookie_jar
        faraday.request :url_encoded
        faraday.request :json
        faraday.response :json, content_type: 'application/json'
        #faraday.request :rate_limiter, interval: 2
        faraday.response :logger, @logger if @logger
        faraday.adapter  :net_http_persistent
      end
    end

  end
end