require 'zobbix'

class ZobbixTest < Minitest::Test
  def zbx
    Zobbix.new(uri: ZABBIX_TEST_URI,
               user: ZABBIX_TEST_USER,
               password: ZABBIX_TEST_PASSWORD)
  end

  def test_low_version
    VCR.use_cassette('check_version/low_version') do
      assert_raises(Zobbix::UnsupportedVersion) { zbx.check_version! }
    end
  end

  def test_high_version
    VCR.use_cassette('check_version/high_version') do
      assert_raises(Zobbix::UnsupportedVersion) { zbx.check_version! }
    end
  end

  def test_ok_version
    VCR.use_cassette('check_version/ok_version') do
      zbx.check_version!
      pass
    end
  end
end