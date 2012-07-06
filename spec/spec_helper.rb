# coding: utf-8

require 'pathname'

Dir[File.dirname(__FILE__) + '/support/*'].each {|f| require f }

PROJECT_ROOT = Pathname.new(__FILE__).dirname.join('..').realpath

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before :suite do
    system 'bundle', chdir: PROJECT_ROOT.join('spec/samples/bundler_project').to_path
  end
end
