# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/dropbox/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-dropbox"
  spec.version       = Fog::Dropbox::VERSION
  spec.authors       = ["Zane Shannon"]
  spec.email         = ["zane@zaneshannon.com"]
  spec.summary       = %q{Module for the 'fog' gem to support Dropbox.}
  spec.description   = %q{This library can be used as a module for `fog` or as standalone provider
                        to use Dropbox in applications.}
  spec.homepage      = "https://github.com/fog/fog-dropbox"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'fog-core'
  spec.add_dependency 'dropbox-sdk'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

  if RUBY_VERSION.to_f > 1.9
    spec.add_development_dependency 'coveralls'
    spec.add_development_dependency 'rubocop'
  end
end
