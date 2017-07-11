# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nba_draft_2017/version"

Gem::Specification.new do |spec|
  spec.name          = "nba-draft-2017"
  spec.version       = NbaDraft2017::VERSION
  spec.authors       = ["Paul Snider"]
  spec.email         = ["pbsnider@gmail.com"]
  spec.summary       = "Retrieve draft picks and corresponding details from the 2017 NBA draft"
  spec.homepage      = "https://github.com/psnider30/nba-draft-2017"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($\)
  spec.executables   = ["nba-draft-2017"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "nokogiri", "~>1.8.0"
  spec.add_runtime_dependency "colorize"
end
