require 'rubygems'

module Reditor
  class LibraryNotFound < LoadError; end

  autoload :LibraryLocator,     'reditor/library_locator'
  autoload :LibrarySearchQuery, 'reditor/library_search_query'
  autoload :Command,            'reditor/command'
  autoload :VERSION,            'reditor/version'
end
