require 'zobbix'

class ZobbixTest < Minitest::Test
  def zbx
    Zobbix.new(uri: ZABBIX_TEST_URI,
               user: ZABBIX_TEST_USER,
               password: ZABBIX_TEST_PASSWORD)
  end

  def test_low_version
    VCR.use_cassette('check_version/low_version') do
      assert_raises(Zobbix::UnsupportedVersionError) { zbx.check_version! }
    end
  end

  def test_high_version
    VCR.use_cassette('check_version/high_version') do
      assert_raises(Zobbix::UnsupportedVersionError) { zbx.check_version! }
    end
  end

  def test_ok_version
    VCR.use_cassette('check_version/ok_version') do
      zbx.check_version!
      pass
    end
  end

  def test_ok_authenticate
    VCR.use_cassette('authentication') do
      zbx.authenticate!
      pass
    end
  end

  def test_bad_authenticate
    VCR.use_cassette('bad_authentication') do
      client = Zobbix.new(uri: ZABBIX_TEST_URI, user: ZABBIX_TEST_USER, password: 'shit')
      assert_raises(Zobbix::AuthenticationError) do
        client.authenticate!
      end
    end
  end

  def test_params_as_array
    VCR.use_cassette('array_params') do
      z = zbx
      z.authenticate!
      response = z.request('host.delete', [10123])
      assert_success(response)
      pass
    end
  end
end
