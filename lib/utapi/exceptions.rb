module UTApi
  class NotLoggedInError < RuntimeError; end # Raised when the client is not logged in/the session has expired
  class LoginError < RuntimeError; end # Raised when there is an error logging in
  class ServerError < RuntimeError; end # Raised when the server returns something strange
  class ApiCallFailed < RuntimeError; end

  class ConnectionError < RuntimeError # Raised when we cannot connect to the server (timeouts mainly)
    attr_reader :wrapped_exception

    def initialize(wrapped_exception, *args, &block)
      @wrapped_exception = wrapped_exception
      super(*args, &block)
    end

    def to_s
      "#{@wrapped_exception.class}: #{super}"
    end
  end

end
