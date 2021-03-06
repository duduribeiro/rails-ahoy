# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ahoy/version'
require 'ahoy'

Gem::Specification.new do |spec|
  spec.name          = "rails-ahoy"
  spec.version       = Ahoy::VERSION
  spec.authors       = ["Nathan Pearson"]
  spec.email         = ["npearson72@gmail.com"]
  spec.summary       = "Quick and painless Rails deployment"
  spec.description   = "Generator for building ansible based provisioning scripts, and mina/puma deployment scripts"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end

