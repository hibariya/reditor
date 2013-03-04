# -*- encoding: utf-8 -*-
require File.expand_path('../lib/reditor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['hibariya']
  gem.email         = ['celluloid.key@gmail.com']
  gem.description   = %q{Open a ruby library by your editor}
  gem.summary       = %q{Open a ruby library by your editor}
  gem.homepage      = 'https://github.com/hibariya/reditor'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'reditor'
  gem.require_paths = ['lib']
  gem.version       = Reditor::VERSION

  gem.add_runtime_dependency 'hotwater', '~> 0.1.2'
  gem.add_runtime_dependency 'thor',     '~> 0.17.0'
  gem.add_runtime_dependency 'rake',     '~> 10.0.3' # workaround for `WARN: Unresolved specs during Gem::Specification.reset: rake (>= 0)' on ruby-2.0.0

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.13.0'
  gem.add_development_dependency 'tapp'
end
