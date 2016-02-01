# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'swift_server'
  spec.version       = '0.0.3'
  spec.authors       = ['mdouchement']
  spec.email         = ['marc.douchement@predicsis.com']
  spec.summary       = 'Swift Server'
  spec.description   = 'Swift-server is a Sinatra server that responds to the same calls Openstack Swift responds to.'
  spec.homepage      = 'https://github.com/mdouchement/swift-server'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%(r{^bin/})) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%(r{^(test|spec|features)/}))
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency 'sinatra', '>= 1.4.0'
  spec.add_dependency 'sinatra-verbs'
  spec.add_dependency 'unicorn'
  spec.add_dependency 'worsemodel', '>= 0.2.0'
  spec.add_dependency 'json'
  spec.add_dependency 'dante'

  spec.add_development_dependency 'bundler', '~> 1.6'
end
