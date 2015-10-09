class Zobbix
  def self.connect(credentials)
    new(credentials).tap(&:connect)
  end

  def self.supported_version?(zabbix_version)
    zabbix_version.to_s =~ /^2\.4\./
  end

  attr_reader :credentials

  def initialize(credentials)
    @credentials = Credentials.new(credentials)
  end
end
