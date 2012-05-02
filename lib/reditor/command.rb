# coding: utf-8

require 'thor'

module Reditor
  class Command < Thor
    include Reditor

    map '-v' => :version,
        '-h' => :help,
        '--version' => :version,
        '--help'    => :help

    desc :open, 'Open the library'
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

    desc :sh, 'Open a shell and move to the library'
    def sh(name)
      dir, _ = *detect(name)

      Dir.chdir dir do
        exec shell_command
      end
    end

    desc :version, 'Show version'
    def version
      say "Reditor version #{VERSION}"
    end

    # XXX FIXME: a more better implementation
    def method_missing(name, *args, &block)
      send :open, name
    end

    private

    def editor_command
      ENV['EDITOR'] or raise '$EDITOR is not provided.'
    end

    def shell_command
      ENV['SHELL'] or raise '$SHELL is not provided.'
    end
  end
end
