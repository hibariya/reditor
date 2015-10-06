require 'pathname'
require 'hotwater'

module Reditor
  class LibrarySearchQuery
    include BundlerSupport

    def self.search(query, options = {})
      new(query, options).search
    end

    attr_reader :query, :options
    attr_reader :half_pattern, :partial_pattern

    def initialize(query, options = {})
      @query   = query.to_s
      @options = {limit: 20, global: false}.merge(options)

      quoted = Regexp.quote(query)
      @half_pattern    = /^#{quoted}|#{quoted}$/i
      @partial_pattern = /#{quoted}/i
    end

    def search(limit = options[:limit])
      candidates.sort_by {|name|
        [*match_scores(name), *distance_scores(name), name]
      }.take(limit)
    end

    def candidates
      @candidates ||= (
        candidates_from_loadpath +
        candidates_from_gem      +
        candidates_from_bundler
      ).uniq
    end

    private

    def match_scores(name)
      words         = name.split(/-_/)
      half_count    = words.grep(half_pattern).count
      partial_count = words.grep(partial_pattern).count

      [-half_count, -partial_count]
    end

    def distance_scores(name)
      [Hotwater.damerau_levenshtein_distance(query, name)]
    end

    def candidates_from_bundler
      return [] if options[:global]

      bundler_specs.map(&:name)
    end

    def candidates_from_gem
      Gem::Specification.map(&:name)
    rescue Gem::LoadError
      []
    end

    def candidates_from_loadpath
      $LOAD_PATH.each_with_object([]) {|path, memo|
        begin
          Pathname(File.expand_path(path)).entries.each do |entry|
              memo << entry.basename('.rb').to_s if entry.extname == '.rb'
          end
        rescue Errno::ENOENT
          # maybe load path is invalid
        end
      }
    end
  end
end
