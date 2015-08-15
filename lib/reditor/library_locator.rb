require 'pathname'

# TODO: care version specification
module Reditor
  class LibraryLocator
    class << self
      def detect(name, options = {})
        new(name.to_s, options).detect
      end

      def detect!(name, options = {})
        detect(name, options) or raise LibraryNotFound, "Can't detect library `#{name}'."
      end
    end

    include BundlerSupport
    include StdlibSupport

    attr_reader :name, :options

    def initialize(name, options)
      @name    = name
      @options = {global: false}.merge(options)
    end

    def detect
      detect_from_stdlib || detect_from_bundler || detect_from_loadpath || detect_from_gem
    end

    def detect_from_stdlib
      return nil unless spec = stdlib_specs.find {|spec| spec.name == name }

      Pathname(spec.path)
    end

    def detect_from_bundler
      return nil if options[:global]
      return nil unless spec = bundler_specs.find {|spec| spec.name == name }

      Pathname(spec.full_gem_path)
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
