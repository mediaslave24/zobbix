require 'zobbix/core_ext/hash'

class Zobbix
  class Credentials
    def initialize(hash)
      @hash = hash.symbolize_keys
    end

    def uri
      @hash.fetch(:uri)
    end

    def user
      @hash.fetch(:user)
    end

    def password
      @hash.fetch(:password)
    end

    def to_hash
      @hash.dup
    end
  end
end
