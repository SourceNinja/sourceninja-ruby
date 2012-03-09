# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "splinter/version"

Gem::Specification.new do |s|
  s.name        = "splinter"
  s.version     = Splinter::VERSION
  s.authors     = ["SourceNinja"]
  s.email       = ["support@sourceninja.com"]
  s.homepage    = "http://www.sourceninja.com"
  s.summary     = %q{Integration with SourceNinja software tracking.}
  s.description = %q{Integration with SourceNinja software tracking. Will allow a user to scan their installed gemlist and automatically populate their product within the SourceNinja system.}

  #s.rubyforge_project = "splinter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  #s.add_development_dependency "
  s.add_runtime_dependency "json"
end
