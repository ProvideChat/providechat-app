# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rspec/log_split/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "rspec-logsplit"
  gem.version       = RSpec::LogSplit::VERSION
  gem.authors       = ["digitalextremist //","Tim Carey-Smith",]
  gem.email         = ["code@extremist.digital","tim@spork.in"]
  gem.description   = %q{A new logger for each example}
  gem.summary       = %q{Separate the logs between examples to allow for easier understanding}
  gem.homepage      = "https://github.com/abstractive/rspec-logsplit"
  gem.license       = "MIT"

  gem.required_ruby_version     = '>= 1.9.2'
  gem.required_rubygems_version = '>= 1.3.6'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
end
