require 'zobbix/credentials'
require 'zobbix/apiinfo/version_request'
require 'zobbix/user/login_request'

require 'rubygems/version'
require 'rubygems/requirement'

class Zobbix
  ZABBIX_VERSION_REQUIREMENT = Gem::Requirement.new('>= 2.2.0', '< 2.5')

  class Error < StandardError; end

  class ConnectionError < Error
    def initialize(credentials)
      super "Can't connect to Zabbix Server #{credentials.to_hash.inspect}"
    end
  end

  class UnsupportedVersionError < Error
    def initialize(version)
      super "Version #{version.inspect} is not supported"
    end
  end

  class AuthenticationError < Error
    def initialize(credentials)
      super "Can't authenticate on Zabbix Server with #{credentials.to_hash.inspect}"
    end
  end

  class UnknownMethodError < Error
    def initialize(method)
      super "Unknown method #{method.inspect}"
    end
  end

  def self.connect(credentials)
    new(credentials)
      .tap(&:check_version!)
      .tap(&:authenticate!)
  end

  def self.supported_version?(zabbix_version)
    zabbix_version.to_s =~ /^2\.4\./
  end

  attr_reader :credentials, :auth

  def initialize(credentials)
    @raise_exceptions = credentials.delete(:raise_exceptions) || false
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
      raise UnsupportedVersionError.new(version)
    end
  end

  def authenticate!
    response = User::LoginRequest.perform(credentials.uri,
                                          credentials.user,
                                          credentials.password)

    unless response.success?
      raise AuthenticationError.new(credentials)
    end

    @auth = response.result
  end

  def request(method, *args)
    request = resolve_class(method)

    response =
      if request
        if requires_auth?(method)
          request.perform(credentials.uri, @auth, *args)
        else
          request.perform(credentials.uri, *args)
        end
      else
        raw_request(method, args.first || {})
      end

    response.raise_exception if @raise_exceptions && response.error?
    response
  end

  private

  def resolve_class(method)
    namespace, mtd = method.split('.').map(&:capitalize)
    self.class.const_get(namespace).const_get("#{mtd}Request")
  rescue NameError
  end

  def raw_request(method, params)
    ApiRequest.perform(credentials.uri, method, params.merge(auth: @auth))
  end

  def requires_auth?(method)
    method = method.to_s
    method != 'apiinfo.version' && method != 'user.login'
  end
end
