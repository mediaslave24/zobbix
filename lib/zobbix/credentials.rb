require 'powerpack/hash/symbolize_keys'

class Zobbix
  class Credentials
    def initialize(hash)
      @hash = hash.symbolize_keys
    end

    def host
      @hash.fetch(:host)
    end

    def port
      @hash.fetch(:port)
    end

    def user
      @hash.fetch(:user)
    end

    def password
      @hash.fetch(:password)
    end
  end
end
