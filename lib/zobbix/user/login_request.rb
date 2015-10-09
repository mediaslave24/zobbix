require 'zobbix/api_request'

class Zobbix
  module User
    class LoginRequest < ApiRequest
      def initialize(uri, user, password)
        super(uri,
              'user.login',
              user: user,
              password: password)
      end
    end
  end
end
