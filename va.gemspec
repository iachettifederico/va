# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'va/version'

Gem::Specification.new do |spec|
  spec.name          = "va"
  spec.version       = Va::VERSION
  spec.authors       = ["Federico Iachetti"]
  spec.email         = ["iachetti.federico@gmail.com"]
  spec.summary       = %q{Minimalistic framework agnostic Validator.}
  spec.description   = %q{Minimalistic framework agnostic Validator.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "cutest", "~> 1.2.2"
end
