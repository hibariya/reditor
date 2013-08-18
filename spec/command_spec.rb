require 'spec_helper'
require 'open3'

describe 'reditor command' do
  def capture_reditor(library_name, options = {})
    options = {editor: 'echo', where: nil}.merge(options)
    command = PROJECT_ROOT.join('bin/reditor').to_path
    project = PROJECT_ROOT.join("spec/samples/#{options[:where]}").to_path

    Bundler.with_clean_env {
      Open3.capture2e(
        {'EDITOR' => options[:editor]},
        command,
        library_name,
        chdir: project
      ).first
    }
  end

  let(:thor_in_bundler_project) { /thor-0\.14\.6/ }

  before :all do
    system 'bundle', chdir: PROJECT_ROOT.join('spec/samples/bundler_project').to_path
  end

  describe '#open' do
    context 'Standard library in non-bundler broject (happy case)' do
      subject { capture_reditor('thread', where: 'blank_project') }

      it { should match /thread\.rb$/ }
    end

    context 'Incorrect name library in non-bundler broject' do
      subject { capture_reditor('cvs', where: 'blank_project') }

      it { should match /\[0\] csv/ }
    end

    context 'rubygems library in non-bundler project' do
      subject { capture_reditor('thor', where: 'blank_project') }

      it { should match /thor-/m }

      specify 'global gem should be used' do
        subject.should_not match thor_in_bundler_project
      end
    end

    context 'rubygems library in bundler project (installed)' do
      subject { capture_reditor('thor', where: 'bundler_project') }

      specify 'bundler gem should be used' do
        subject.should match thor_in_bundler_project
      end
    end

    context 'rubygems library in bundler project (not yet installed)' do
      subject { capture_reditor('thor', where: 'bundler_project_without_lockfile') }

      it { should match thor_in_bundler_project }
    end

    context 'with incorrect name' do
      subject { capture_reditor('thief') }

      it { should match /\[\d+\]\sthread/ }
      it { should match /\[\d+\]\sthor/ }
      it { should match /Choose number of library/ }
    end
  end
end
