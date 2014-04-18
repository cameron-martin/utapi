module UTApi
  class Account

    attr_reader :email, :password, :hash, :platform

    def initialize(data)
      @email = data[:email]
      @password = data[:password]
      @hash = data[:hash]
      @platform = data[:platform]
    end

  end
end