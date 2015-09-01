# -*- encoding: utf-8 -*-
# stub: lograge 0.3.4 ruby lib

Gem::Specification.new do |s|
  s.name = "lograge"
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mathias Meyer", "Ben Lovell"]
  s.date = "2015-07-07"
  s.description = "Tame Rails' multi-line logging into a single line per request"
  s.email = ["meyer@paperplanes.de", "benjamin.lovell@gmail.com"]
  s.homepage = "https://github.com/roidrage/lograge"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "Tame Rails' multi-line logging into a single line per request"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3"])
      s.add_runtime_dependency(%q<railties>, [">= 3"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 3"])
      s.add_dependency(%q<actionpack>, [">= 3"])
      s.add_dependency(%q<railties>, [">= 3"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 3"])
    s.add_dependency(%q<actionpack>, [">= 3"])
    s.add_dependency(%q<railties>, [">= 3"])
  end
end
