require 'zobbix/api_request'

class Zobbix
  class ApiRequestTest < Minitest::Test
    def request(uri, method, params)
      ApiRequest.new(uri, method, params).perform
    end

    def test_it_makes_successful_request
      VCR.use_cassette('api_request') do
        response = request(ZABBIX_TEST_URI, 'apiinfo.version', {})
        assert_success(response)
        assert_equal(response.result, '2.4.6')
      end
    end
  end
end
