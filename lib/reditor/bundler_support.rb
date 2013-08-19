module Reditor
  # Reditor doesn't depend on bundler, But use it if available.
  module BundlerSupport
    # **available** bundler specs
    def bundler_specs
      require 'bundler'

      Bundler.load.specs
    rescue LoadError, NameError, Bundler::GemNotFound, Bundler::GemfileNotFound, Bundler::GitError
      [] # bundler isn't available here
    end
  end
end
