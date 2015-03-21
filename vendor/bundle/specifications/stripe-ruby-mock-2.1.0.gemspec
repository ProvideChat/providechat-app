# -*- encoding: utf-8 -*-
# stub: stripe-ruby-mock 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "stripe-ruby-mock"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gilbert"]
  s.date = "2015-02-27"
  s.description = "A drop-in library to test stripe without hitting their servers"
  s.email = "gilbertbgarza@gmail.com"
  s.executables = ["stripe-mock-server"]
  s.files = ["bin/stripe-mock-server"]
  s.homepage = "https://github.com/rebelidealist/stripe-ruby-mock"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "TDD with stripe"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<stripe>, [">= 1.20.1"])
      s.add_runtime_dependency(%q<jimson-temp>, [">= 0"])
      s.add_runtime_dependency(%q<dante>, [">= 0.2.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1.0"])
      s.add_development_dependency(%q<rubygems-tasks>, ["~> 0.2"])
      s.add_development_dependency(%q<thin>, [">= 0"])
    else
      s.add_dependency(%q<stripe>, [">= 1.20.1"])
      s.add_dependency(%q<jimson-temp>, [">= 0"])
      s.add_dependency(%q<dante>, [">= 0.2.0"])
      s.add_dependency(%q<rspec>, ["~> 3.1.0"])
      s.add_dependency(%q<rubygems-tasks>, ["~> 0.2"])
      s.add_dependency(%q<thin>, [">= 0"])
    end
  else
    s.add_dependency(%q<stripe>, [">= 1.20.1"])
    s.add_dependency(%q<jimson-temp>, [">= 0"])
    s.add_dependency(%q<dante>, [">= 0.2.0"])
    s.add_dependency(%q<rspec>, ["~> 3.1.0"])
    s.add_dependency(%q<rubygems-tasks>, ["~> 0.2"])
    s.add_dependency(%q<thin>, [">= 0"])
  end
end
