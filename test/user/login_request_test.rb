require 'test_helper'
require 'zobbix/user/login_request'

class Zobbix
  module User
    class LoginRequestTest < Minitest::Test
      def test_it_logins_successfully
        VCR.use_cassette('user.login') do
          refute_nil LoginRequest.perform(ZABBIX_TEST_URI, 'Admin', 'zabbix').result
        end
      end
    end
  end
end
