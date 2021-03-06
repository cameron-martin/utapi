# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utapi/version'

Gem::Specification.new do |spec|
  spec.name          = 'utapi'
  spec.version       = UTApi::VERSION
  spec.authors       = ['Cameron Martin']
  spec.email         = ['cameronmartin123@gmail.com']
  spec.description   = %q{FIFA 14 Ultimate Team api in Ruby}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/cameron-martin/utapi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'dotenv'

  spec.add_runtime_dependency 'faraday', '~> 0.9.0'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.9.0'
  spec.add_runtime_dependency 'faraday-cookie_jar'
  spec.add_runtime_dependency 'faraday-rate_limiter'

  spec.add_runtime_dependency 'net-http-persistent'
  spec.add_runtime_dependency 'rattributes'
end
