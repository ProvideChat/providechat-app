# -*- encoding: utf-8 -*-
# stub: dante 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "dante"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nathan Esquenazi"]
  s.date = "2013-12-04"
  s.description = "Turn any process into a demon."
  s.email = ["nesquena@gmail.com"]
  s.homepage = "https://github.com/bazaarlabs/dante"
  s.rubyforge_project = "dante"
  s.rubygems_version = "2.4.5"
  s.summary = "Turn any process into a demon"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
