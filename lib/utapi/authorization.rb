module UTApi
  class Authorization

    attr_reader :server, :phishing_token, :sid

    def initialize(data)
      @server = data[:server]
      @phishing_token = data[:phishing_token]
      @sid = data[:sid]
    end
  end
end