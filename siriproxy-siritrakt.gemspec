# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-siritrakt"
  s.version     = "0.0.1"
  s.authors     = ["matsimitsu"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{A Siri Proxy plugin that retrieves data from trakt.tv}
  s.description = %q{A Siri Proxy plugin that retrieves data from trakt.tv}

  s.rubyforge_project = "siriproxy-siritrakt"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "typhoeus"
  s.add_runtime_dependency 'yajl-ruby'
end
