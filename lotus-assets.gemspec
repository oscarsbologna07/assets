# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lotus/assets/version'

Gem::Specification.new do |spec|
  spec.name          = 'lotus-assets'
  spec.version       = Lotus::Assets::VERSION
  spec.authors       = ['Luca Guidi']
  spec.email         = ['me@lucaguidi.com']
  spec.summary       = %q{Assets management}
  spec.description   = %q{Assets management for Ruby web applications}
  spec.homepage      = 'http://lotusrb.org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -- lib/* LICENSE.md README.md lotus-assets.gemspec`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lotus-utils',    '~> 0.6'
  spec.add_runtime_dependency 'tilt',           '~> 2.0', '>= 2.0.1'
  spec.add_runtime_dependency 'yui-compressor', '~> 0.12'

  spec.add_development_dependency 'bundler',          '~> 1.6'
  spec.add_development_dependency 'rake',             '~> 10'
  spec.add_development_dependency 'minitest',         '~> 5'
  spec.add_development_dependency 'coffee-script',    '~> 2.3'
  spec.add_development_dependency 'sass',             '~> 3.4'
  spec.add_development_dependency 'babel-transpiler', '~> 0.7'
end
