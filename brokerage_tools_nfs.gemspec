# -*- encoding: utf-8 -*-
require File.expand_path('../lib/brokerage_tools_nfs/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Weppler"]
  gem.email         = ["mweppler@gmail.com"]
  gem.description   = %q{Brokerage Tools Specific to parsing data files provided by NFS (National Finanical Services)}
  gem.summary       = %q{Brokerage Tools NFS (National Finanical Services)}
  gem.homepage      = "http://mattweppler.info"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "brokerage_tools_nfs"
  gem.require_paths = ["lib"]
  gem.version       = BrokerageToolsNfs::VERSION

  gem.add_development_dependency "rspec"
  gem.add_dependency "activerecord"
  gem.add_dependency "rubyzip"
  

end
