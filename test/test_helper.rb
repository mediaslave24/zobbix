require 'minitest/autorun'
require 'ffaker'
require 'vcr'

ZABBIX_TEST_URI = ENV.fetch('ZABBIX_TEST_URI', 'http://localhost/zabbix')

module Minitest::Assertions
  def assert_success(object)
    assert object.success?,
      "Expected #{object.inspect}.success? to be true, but have false"
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_casettes'
  config.hook_into :webmock
end
