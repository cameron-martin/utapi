require 'faraday'
require 'utapi/exceptions'

module Faraday
  class ErrorHandler < Middleware


    def call(env)

      begin
        response = @app.call(env)
      rescue Net::ReadTimeout, Errno::ETIMEDOUT, Timeout::Error, Faraday::Error::TimeoutError => e # Timeout Errors
        raise UTApi::ConnectionError.new(e, response_values(env))
      end

      response.on_complete do |env|
        handle_return_errors(env)
      end

    end

    def handle_return_errors(env)
      case env[:status]
        when 302, 200
          # Let them pass through
        when 401
          raise UTApi::NotLoggedInError, response_values(env)
        else
          raise UTApi::ServerError, response_values(env)
      end
    end

    def response_values(env)
      {:status => env.status, :headers => env.response_headers, :body => env.body}
    end

  end
end

Faraday::Middleware.register_middleware(:error_handler => Faraday::ErrorHandler)