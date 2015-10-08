class Zobbix
  def self.connect(credentials)
    new(credentials).tap(&:connect)
  end

  attr_reader :credentials

  def initialize(credentials)
    @credentials = Credentials.new(credentials)
  end
end
