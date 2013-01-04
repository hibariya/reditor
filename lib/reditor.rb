require 'rubygems'

module Reditor
  class LibraryNotFound < LoadError; end

  autoload :LibraryLocator,    'reditor/library_locator'
  autoload :CandidatesLocator, 'reditor/candidates_locator'
  autoload :Command,           'reditor/command'
  autoload :VERSION,           'reditor/version'
end
