# coding: utf-8

require 'thor'

module Reditor
  class Command < Thor
    class << self
      attr_accessor :restarted

      def restart(args)
        self.restarted = true

        start args
      end
    end

    map '-v' => :version,
        '-h' => :help,
        '--version' => :version,
        '--help'    => :help

    desc 'open [NAME]', 'Detect and open a library'
    method_options global: false
    def open(name)
      detect_exec name, global: options[:global] do |dir, file|
        say "Moving to #{dir}", :green
        Dir.chdir dir do
          say "Opening #{file}", :green

          exec editor_command, file
        end
      end
    end

    desc 'sh [NAME]', 'Detect and open a library by $SHELL'
    method_options global: false
    def sh(name)
      detect_exec name, global: options[:global] do |dir, _|
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

    private

    def method_missing(name, *args, &block)
      return super if Command.restarted

      Command.restart ['open', name, *args]
    end

    def detect_exec(name, options = {}, &block)
      path = LibraryLocator.detect(name, options)

      return choose_exec name, options, &block unless path

      dir, file =
        if path.file?
          [path.dirname.to_path, path.basename.to_path]
        else
          [path.to_path, '.']
        end

      block.call dir, file
    end

    def choose_exec(name, options = {}, &block)
      names = LibrarySearchQuery.search(name, options)

      names.each.with_index do |name, i|
        say "[#{i}] #{name}"
      end
      print 'Choose number of library [0]> '

      abort_reditor unless num = $stdin.gets

      detect_exec names[num.to_i], options, &block
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
