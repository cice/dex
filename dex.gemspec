# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dex/version"

Gem::Specification.new do |s|
  s.name        = "dex"
  s.version     = Dex::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '~> 2.7.0'
  s.add_development_dependency 'rspec-mocks', '~> 2.7.0'
  s.add_development_dependency 'rspec-expectations', '~> 2.7.0'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rake'

  s.add_dependency 'activesupport', '~> 3.1.1'
  s.add_dependency 'i18n'
end
