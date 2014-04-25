module UTApi
  class Authorization
    include Attributer.new(:server, :phishing_token, :sid)
  end
end