$:.unshift(File.expand_path('../lib', __FILE__))
require 'zobbix/version'

Gem::Specification.new do |spec|
  spec.name          = "zobbix"
  spec.version       = Zobbix::VERSION
  spec.authors       = ["Michael Lutsiuk"]
  spec.email         = ["michael.lutsiuk@gmail.com"]
  spec.summary       = "Zabbix API Wrapper"
  spec.description   = "Minimal wrapper for Zabbix Server API"
  spec.homepage      = "https://github.com/mediaslave24/zobbix"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.8'
  spec.add_development_dependency 'ffaker', '~> 2.1'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'pry', '~> 0.10'

  spec.add_runtime_dependency 'httparty', '~> 0.13'
end
