module UTApi
  class Account
    include Attributer.new(:email, :password, :hash, :platform)
  end
end