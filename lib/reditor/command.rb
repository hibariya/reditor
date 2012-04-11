# coding: utf-8

require 'thor'
require 'pathname'
require 'rubygems'

module Reditor
  class LibraryNotFound < LoadError; end

  class Command < Thor
    desc :open, 'open a library'
    def open(name)
      dir, file = *detect(name)

      say "Moving to #{dir}", :green
      Dir.chdir dir do
        say "Opening #{file}", :green

        exec editor_command, file
      end
    rescue LibraryNotFound => e
      say e.message, :red
    end

    # XXX FIXME: a more better implementation
    def method_missing(name, *args, &block)
      send :open, name
    end

    private

    def editor_command
      ENV['EDITOR']
    end

    def detect(name)
      path = detect_library_path(name) or raise LibraryNotFound, 'No library found'

      if path.file?
        [path.dirname.to_path, path.basename.to_path]
      else
        [path.to_path, '.']
      end
    end

    def detect_library_path(name)
      detect_library_path_from_loadpath(name) || detect_library_path_from_gem(name)
    end

    def detect_library_path_from_loadpath(name)
      basename = "#{name}.rb"

      $LOAD_PATH.map {|path|
        full_path = File.expand_path(path + '/' + basename)

        Pathname.new(full_path)
      }.detect(&:exist?)
    end

    # TODO: care version specification
    def detect_library_path_from_gem(name)
      spec = Gem::Specification.find_by_name(name.to_s)

      Pathname.new(spec.full_gem_path)
    rescue Gem::LoadError
      nil
    end
  end
end
