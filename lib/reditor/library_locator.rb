require 'pathname'

# TODO: care version specification
module Reditor
  class LibraryLocator
    def self.detect(name)
      new(name.to_s).detect
    end

    attr_reader :name

    def initialize(name)
      @name  = name
    end

    def detect
      detect_from_bundler || detect_from_loadpath || detect_from_gem
    end

    def detect_from_bundler
      require 'bundler'

      return nil unless spec = Bundler.load.specs.find {|spec| spec.name == name }

      Pathname(spec.full_gem_path)
    rescue NameError, Bundler::GemNotFound, Bundler::GemfileNotFound
      # NOP (probably it's not available bundler project)
    end

    def detect_from_loadpath
      basename = "#{name}.rb"

      $LOAD_PATH.map {|path|
        full_path = File.expand_path(path + '/' + basename)

        Pathname(full_path)
      }.detect(&:exist?)
    end

    def detect_from_gem
      spec = Gem::Specification.find_by_name(name)

      Pathname(spec.full_gem_path)
    rescue Gem::LoadError
      # NOP (Gem couldn't find #{name} gem)
    end
  end
end
