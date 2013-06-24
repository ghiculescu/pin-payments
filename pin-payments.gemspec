# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'pin-payments'
  s.version     = '0.0.1'
  s.date        = '2013-06-23'
  s.summary     = "Pin Payments API wrapper"
  s.description = "A wrapper for the Pin Payments (https://pin.net.au/) API"
  s.authors     = ["Alex Ghiculescu"]
  s.email       = 'alexghiculescu@gmail.com'
  s.files       = Dir.glob('lib/*')
  s.licenses    = ["MIT"]
  s.require_paths = ["lib"]
  s.homepage    = 'https://github.com/ghiculescu/pin-payments'

  s.add_dependency "httparty"
  s.add_dependency "json"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "webmock"
end