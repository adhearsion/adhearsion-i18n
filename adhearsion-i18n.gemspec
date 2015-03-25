# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "adhearsion-i18n/version"

Gem::Specification.new do |s|
  s.name        = "adhearsion-i18n"
  s.version     = AdhearsionI18n::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Klang", "Justin Aiken"]
  s.email       = "dev@adhearsion.com"
  s.homepage    = "http://adhearsion.com"
  s.summary     = "Internationalization helpers for Adhearsion applications"
  s.description = "This provides helpers that manage internationalized audio prompts, both file-based and text-based"

  s.license = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'activesupport', [">= 3.0.0", "< 5.0.0"]
  s.add_runtime_dependency 'adhearsion', ["~> 2.5"]
  s.add_runtime_dependency 'i18n', ["~> 0.6.0"]

  s.add_development_dependency 'rspec', ["~> 2.11"]
end
