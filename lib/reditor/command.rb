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
        say "Moving to #{dir}", :green
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
      path = LibraryLocator.detect(name)

      return choose_exec name, &block unless path

      dir, file =
        if path.file?
          [path.dirname.to_path, path.basename.to_path]
        else
          [path.to_path, '.']
        end

      block.call dir, file
    end

    def choose_exec(name, &block)
      candidates = CandidatesLocator.detect(name)

      candidates.each.with_index do |candidate, i|
        say "[#{i}] #{candidate}"
      end
      print "Choose number of library [0]> "

      abort_reditor unless num = $stdin.gets

      detect_exec candidates[num.to_i], &block
    rescue Interrupt
      abort_reditor
    end

    def editor_command
      ENV['EDITOR'] or raise '$EDITOR is not provided.'
    end

    def shell_command
      ENV['SHELL'] or raise '$SHELL is not provided.'
    end

    def abort_reditor
      puts

      exit
    end
  end
end
