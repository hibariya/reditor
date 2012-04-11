# coding: utf-8

require 'thor'

module Reditor
  class Command < Thor
    include Reditor

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

    desc :version, 'show version'
    def version
      say "Reditor version #{VERSION}"
    end

    # XXX FIXME: a more better implementation
    def method_missing(name, *args, &block)
      send :open, name
    end

    private

    def editor_command
      ENV['EDITOR']
    end
  end
end
