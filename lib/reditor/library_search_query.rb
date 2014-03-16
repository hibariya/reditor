require 'pathname'
require 'hotwater'

module Reditor
  class LibrarySearchQuery
    include BundlerSupport

    def self.search(query, options = {})
      new(query, options).search
    end

    attr_reader :query, :options
    attr_reader :substr_pattern, :partial_pattern

    def initialize(query, options = {})
      @query   = query.to_s
      @options = {limit: 20, global: false}.merge(options)

      quoted = Regexp.quote(query)
      @substr_pattern  = /^#{quoted}|#{quoted}$/i
      @partial_pattern = /#{quoted}/i
    end

    def search(limit = options[:limit])
      available_libraries.sort_by {|name|
        indexes_with_match(name) + indexes_with_distance(name)
      }.take(limit)
    end

    def available_libraries
      @available_libraries ||= (
        availables_from_loadpath +
        availables_from_gem      +
        availables_from_bundler
      ).uniq
    end

    private

    def indexes_with_match(name)
      words         = name.split(/-_/)
      substr_count  = words.grep(substr_pattern).count
      partial_count = words.grep(partial_pattern).count

      [-substr_count, -partial_count]
    end

    def indexes_with_distance(name)
      [Hotwater.damerau_levenshtein_distance(query, name)]
    end

    def availables_from_bundler
      return [] if options[:global]

      bundler_specs.map(&:name)
    end

    def availables_from_gem
      Gem::Specification.map(&:name)
    rescue Gem::LoadError
      []
    end

    def availables_from_loadpath
      $LOAD_PATH.each_with_object([]) {|path, availables|
        Pathname(File.expand_path(path)).entries.each do |entry|
          availables << entry.basename('.rb').to_s if entry.extname == '.rb'
        end
      }
    end
  end
end
