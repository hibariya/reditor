# coding: utf-8

require 'pathname'

Dir[File.dirname(__FILE__) + '/support/*'].each {|f| require f }

PROJECT_ROOT = Pathname.new(__FILE__).dirname.join('..').realpath

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end
