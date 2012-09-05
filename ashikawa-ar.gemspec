# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ashikawa-ar/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["moonglum"]
  gem.email         = ["moonglum@moonbeamlabs.com"]
  gem.description   = %q{ArangoDB ODM for Ruby using the ActiveRecord Pattern}
  gem.summary       = %q{ArangoDB ODM for Ruby using the ActiveRecord Pattern.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ashikawa-ar"
  gem.require_paths = ["lib"]
  gem.version       = Ashikawa::AR::VERSION
end
