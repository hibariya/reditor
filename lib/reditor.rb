require 'pathname'
require 'rubygems'

def gemfile_found?
  if File.exists? 'Gemfile'
    true
  elsif (Dir.getwd != '/')
    Dir.chdir('..')
    gemfile_found?
  end
end

if (gemfile_found?)
  require 'bundler'
  Bundler.setup
end

module Reditor
  class LibraryNotFound < LoadError; end

  extend self

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

  autoload :Command, 'reditor/command'
  autoload :VERSION, 'reditor/version'
end
