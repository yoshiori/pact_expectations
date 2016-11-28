# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pact_expectations/version'

Gem::Specification.new do |spec|
  spec.name          = "pact_expectations"
  spec.version       = PactExpectations::VERSION
  spec.authors       = ["Yoshiori SHOJI"]
  spec.email         = ["yoshiori@gmail.com"]

  spec.summary       = %q{Pact response convert to stub.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/yoshiori/pact_expectations"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pact-support", ">= 0.5.4"

  spec.add_development_dependency "pact", ">= 1.9"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
