require 'pathname'
require 'bundler'

module Reditor
  class CandidatesLocator
    def self.detect(keyword)
      new(keyword.to_s).detect
    end

    attr_reader :pattern

    def initialize(keyword)
      tokens = keyword.split(/[_\-]/).map {|keyword|
        keyword.length > 4 ? keyword[0...-3] : keyword
      }

      @pattern = /#{tokens.map {|t| Regexp.quote(t) }.join('|')}/i
    end

    def detect
      (detect_from_bundler + detect_from_loadpath + detect_from_gem).sort.uniq
    end

    def detect_from_bundler
      Bundler.load.specs.select {|spec| spec.name =~ pattern }.map(&:name)
    rescue NameError # ensure enviroments that bundler isn't installed
    end

    def detect_from_loadpath
      $LOAD_PATH.map {|path|
        pathname = Pathname.new(File.expand_path(path))

        pathname.entries.select {|entry|
          entry.to_path =~ pattern
        }.map {|entry| entry.basename('.*').to_path }
      }.flatten
    end

    def detect_from_gem
      Gem::Specification.each.select {|spec| spec.name =~ pattern }.map(&:name)
    end
  end
end
