require 'pathname'

# TODO: care multi candidates
# TODO: care version specification
module Reditor
  class LibraryLocator
    def self.detect(name)
      new(name).detect
    end

    attr_reader :name

    def initialize(name)
      @name  = name
    end

    def detect
      path = detect_library_path or raise LibraryNotFound, 'No library found'

      if path.file?
        [path.dirname.to_path, path.basename.to_path]
      else
        [path.to_path, '.']
      end
    end

    def detect_library_path
      detect_library_path_from_bundler    ||
        detect_library_path_from_loadpath ||
        detect_library_path_from_gem
    end

    def detect_library_path_from_loadpath
      basename = "#{name}.rb"

      $LOAD_PATH.map {|path|
        full_path = File.expand_path(path + '/' + basename)

        Pathname.new(full_path)
      }.detect(&:exist?)
    end

    def detect_library_path_from_gem
      spec = Gem::Specification.find_by_name(name.to_s)

      Pathname.new(spec.full_gem_path)
    rescue Gem::LoadError
      nil
    end

    def detect_library_path_from_bundler
      return nil unless spec = Bundler.load.specs.find {|spec| spec.name == name.to_s }

      Pathname.new(spec.full_gem_path)
    rescue Bundler::GemNotFound, Bundler::GemfileNotFound
      nil
    end
  end
end
