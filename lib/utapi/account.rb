module UTApi
  class Account
    include Rattributes.new(:email, :password, :hash, :platform)
  end
end