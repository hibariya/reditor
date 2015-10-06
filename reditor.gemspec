# -*- encoding: utf-8 -*-
require File.expand_path('../lib/reditor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['hibariya']
  gem.email         = ['celluloid.key@gmail.com']
  gem.description   = %q{Open a ruby library with $EDITOR. Reditor supports rubygems, bundler, and stdlib (pure ruby).}
  gem.summary       = %q{Open a ruby library with $EDITOR.}
  gem.homepage      = 'https://github.com/hibariya/reditor'
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'reditor'
  gem.require_paths = ['lib']
  gem.version       = Reditor::VERSION

  gem.add_runtime_dependency 'hotwater', '~> 0.1.2'
  gem.add_runtime_dependency 'pepin',    '~> 0.1.0'
  gem.add_runtime_dependency 'thor',     '~> 0.19.1'

  gem.add_development_dependency 'rake', '~> 10.4.2'
  gem.add_development_dependency 'rspec', '~> 3.3.0'
end
