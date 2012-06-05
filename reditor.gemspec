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

  gem.add_runtime_dependency 'thor',    '>= 0.14.6'
  gem.add_runtime_dependency 'bundler', '>= 1.1.4'
end
