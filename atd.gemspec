# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atd/version'

Gem::Specification.new do |spec|
  spec.name          = "atd"
  spec.version       = ATD::VERSION
  spec.authors       = ["Son Dinh"]
  spec.email         = ["dnson272@gmail.com"]

  spec.summary       = %q{Autoload data.}
  spec.description   = %q{Autoload data.}
  spec.homepage      = "https://github.com/dnson272/atd"

 
  spec.files          = Dir['lib/**/*.rb'] + Dir['bin/*']
  spec.executables    = 'atd'
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ["lib"]

  spec.add_dependency 'lotus-utils',      '~> 0.4'
  spec.add_dependency 'thor', '~> 0.19'


  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
