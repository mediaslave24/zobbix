require 'zobbix/credentials'
require 'zobbix/api_request'
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

  #
  # @param [Hash] credentials Connection credentials
  # @option opts [String] :uri Zabbix Server URI
  # @option opts [String] :user
  # @option opts [String] :password
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

  # Checks API version
  #
  # @note This method should be called automatically
  # @raise Zobbix::ConnectionError Can't establish connection
  # @raise Zobbix::UnsupportedVersionError Bad API version
  def check_version!
    version = request('apiinfo.version').result

    if version.nil?
      raise ConnectionError.new(credentials)
    end

    version = Gem::Version.new(version)
    unless ZABBIX_VERSION_REQUIREMENT.satisfied_by?(version)
      raise UnsupportedVersionError.new(version)
    end
  end

  # Performs authentication
  #
  # @return [String] Auth token
  # @see https://www.zabbix.com/documentation/2.4/manual/api#authentication
  # @note This method should be called automatically
  #
  # @raise Zobbix::AuthenticationError
  def authenticate!
    response = request('user.login', user: credentials.user,
                                     password: credentials.password)

    unless response.success?
      raise AuthenticationError.new(credentials)
    end

    @auth = response.result
  end

  # Makes API request
  #
  # @param [String] method Request method
  # @param [Hash] params Request params
  # @return [Zobbix::ApiResponse] Response object
  #
  # @see https://www.zabbix.com/documentation/2.4/manual/api/reference
  def request(method, params = {})
    params = params.merge(auth: @auth) if requires_auth?(method)

    response = ApiRequest.perform(credentials.uri, method, params)
    response.raise_exception if @raise_exceptions && response.error?
    response
  end

  private

  def requires_auth?(method)
    method = method.to_s
    method != 'apiinfo.version' && method != 'user.login'
  end
end
