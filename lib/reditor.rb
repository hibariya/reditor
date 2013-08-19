require 'rubygems'

# load all dependencies (https://github.com/hibariya/reditor/issues/4)
require 'hotwater'
require 'thor'
require 'rake'

module Reditor
  class LibraryNotFound < LoadError; end

  autoload :LibraryLocator,     'reditor/library_locator'
  autoload :LibrarySearchQuery, 'reditor/library_search_query'
  autoload :BundlerSupport,     'reditor/bundler_support'
  autoload :Command,            'reditor/command'
  autoload :VERSION,            'reditor/version'
end
