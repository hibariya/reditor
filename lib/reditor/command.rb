# coding: utf-8

require 'thor'

module Reditor
  class Command < Thor
    map '-v' => :version,
        '-h' => :help,
        '--version' => :version,
        '--help'    => :help

    desc :open, 'Open the library'
    def open(name)
      detect_exec name do |dir, file|
        say "Moving to #{dir}", :green
        Dir.chdir dir do
          say "Opening #{file}", :green

          exec editor_command, file
        end
      end
    end

    desc :sh, 'Open a shell and move to the library'
    def sh(name)
      detect_exec name do |dir, _|
        Dir.chdir dir do
          exec shell_command
        end
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

    def detect_exec(name, &block)
      block.call *LibraryLocator.detect(name)
    rescue LibraryNotFound => e
      say e.message, :red
    end

    def editor_command
      ENV['EDITOR'] or raise '$EDITOR is not provided.'
    end

    def shell_command
      ENV['SHELL'] or raise '$SHELL is not provided.'
    end
  end
end
