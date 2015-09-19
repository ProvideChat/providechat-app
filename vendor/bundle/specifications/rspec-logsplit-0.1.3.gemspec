# -*- encoding: utf-8 -*-
# stub: rspec-logsplit 0.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-logsplit"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["digitalextremist //", "Tim Carey-Smith"]
  s.date = "2015-05-04"
  s.description = "A new logger for each example"
  s.email = ["code@extremist.digital", "tim@spork.in"]
  s.homepage = "https://github.com/abstractive/rspec-logsplit"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.4.5.1"
  s.summary = "Separate the logs between examples to allow for easier understanding"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
  end
end
