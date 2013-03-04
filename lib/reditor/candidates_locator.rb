require 'pathname'
require 'hotwater'

module Reditor
  class CandidatesLocator
    def self.detect(keyword)
      new(keyword.to_s).detect
    end

    attr_reader :keyword, :limit

    def initialize(keyword, limit = 20)
      @keyword, @limit = keyword, limit
    end

    def detect
      available_libraries.sort_by {|name|
        Hotwater.damerau_levenshtein_distance(@keyword, name)
      }.take(@limit)
    end

    # XXX
    def available_libraries
      (availables_from_loadpath +
       availables_from_gem      +
       availables_from_bundler).uniq
    end

    private

    def availables_from_bundler
      require 'bundler'

      Bundler.load.specs.map(&:name)
    rescue NameError, Bundler::GemNotFound, Bundler::GemfileNotFound
      []
    end

    def availables_from_gem
      Gem::Specification.map(&:name)
    rescue Gem::LoadError
      []
    end

    def availables_from_loadpath
      $LOAD_PATH.each_with_object([]) {|path, availables|
        Pathname.new(File.expand_path(path)).entries.each do |entry|
          availables << entry.basename('.rb').to_s if entry.extname == '.rb'
        end
      }
    end
  end
end
