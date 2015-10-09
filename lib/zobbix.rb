require 'zobbix/apiinfo/version_request'
require 'zobbix/user/login_request'

require 'rubygems/version'
require 'rubygems/requirement'

class Zobbix
  ZABBIX_VERSION_REQUIREMENT = Gem::Requirement.new('>= 2.4.0', '< 2.5')

  class Error < StandardError; end

  class ConnectionError < Error
    def initialize(credentials)
      super "Can't connect to Zabbix Server #{credentials.to_hash.inspect}"
    end
  end

  class UnsupportedVersion < Error
    def initialize(version)
      super "Version #{version.inspect} is not supported"
    end
  end

  def self.connect(credentials)
    new(credentials)
      .tap(&:check_version!)
      .tap(&:authenticate)
  end

  def self.supported_version?(zabbix_version)
    zabbix_version.to_s =~ /^2\.4\./
  end

  attr_reader :credentials

  def initialize(credentials)
    @credentials = Credentials.new(credentials)
    @auth        = nil
  end

  def check_version!
    version = Apiinfo::VersionRequest.perform(credentials.uri).result

    if version.nil?
      raise ConnectionError.new(credentials)
    end

    version = Gem::Version.new(version)
    unless ZABBIX_VERSION_REQUIREMENT.satisfied_by?(version)
      raise UnsupportedVersion.new(version)
    end
  end

  def connect
  end
end
