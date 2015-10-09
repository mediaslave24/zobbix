require 'test_helper'
require 'zobbix/apiinfo/version_request'

class Zobbix
  module Apiinfo
    class VersionRequestTest < Minitest::Test
      def test_it_makes_correct_request
        VCR.use_cassette('apiinfo.version') do
          VersionRequest.perform(ZABBIX_TEST_URI)
        end
      end
    end
  end
end
