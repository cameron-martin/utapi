module UTApi
  class Authorization
    include Rattributes.new(:server, :phishing_token, :sid)
  end
end