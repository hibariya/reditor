require 'spec_helper'
require 'open3'

describe 'reditor command' do
  def capture_reditor(library_name, options)
    options = {editor: 'echo', where: nil}.merge(options)
    command = PROJECT_ROOT.join('bin/reditor').to_path
    project = PROJECT_ROOT.join("spec/samples/#{options[:where]}").to_path

    Open3.capture2(
      {'EDITOR' => options[:editor]},
      command,
      library_name,
      chdir: project
    ).first
  end

  describe '#open' do
    context 'Standard library in non-bundler broject (happy case)' do
      subject { capture_reditor('thread', where: 'blank_project') }

      it { should match /thread\.rb$/ }
    end

    context 'Standard library in non-bundler broject (no library found)' do
      subject { capture_reditor('3600645b1f28d73e9cd0384b5b9664d6ceeabe7e', where: 'blank_project') }

      it { should match 'No library found' }
    end

    context 'rubygems library in non-bundler project' do
      subject { capture_reditor('thor', where: 'blank_project') }

      it { should match /thor-/m }

      specify 'global gem should be used' do
        subject.should_not match /thor-0\.14\.6/
      end
    end

    context 'rubygems library in bundler project (installed)' do
      subject { capture_reditor('thor', where: 'bundler_project') }

      specify 'bundler gem should be used' do
        subject.should match /thor-0\.14\.6/
      end
    end

    context 'rubygems library in bundler project (not yet installed)' do
      subject { capture_reditor('thor', where: 'bundler_project_without_lockfile') }

      it { should match /thor-0\.14\.6/ }
    end
  end
end
