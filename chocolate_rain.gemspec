# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chocolate_rain/version"

Gem::Specification.new do |s|
  s.name        = "chocolate_rain"
  s.version     = ChocolateRain::VERSION
  s.authors     = ["Kevin Hopkins"]
  s.email       = ["kevin@wearefound.com"]
  s.homepage    = ""
  s.summary     = %q{Monitor E-Mail and FTP for videos to upload to YouTube}
  s.description = %q{Monitor E-Mail and FTP for videos to upload to YouTube}

  s.rubyforge_project = "chocolate_rain"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "youtube_it"
end
