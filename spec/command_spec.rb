require 'spec_helper'
require 'open3'

describe 'reditor command' do
  def capture_reditor(library_name, options = {})
    options = {editor: 'echo', where: nil}.merge(options)
    command = PROJECT_ROOT.join('bin/reditor').to_path
    project = PROJECT_ROOT.join("spec/samples/#{options[:where]}").to_path

    Open3.capture2e(
      {'EDITOR' => options[:editor]},
      command,
      library_name,
      chdir: project
    ).first
  end

  let(:thor_in_bundler_project) { /thor-0\.14\.6/ }

  describe '#open' do
    context 'Standard library in non-bundler broject (happy case)' do
      subject { capture_reditor('thread', where: 'blank_project') }

      it { should match /thread\.rb$/ }
    end

    context 'Standard library in non-bundler broject (no library found)' do
      subject { capture_reditor('3600645b1f28d73e9cd0384b5b9664d6ceeabe7e', where: 'blank_project') }

      it { should match 'Library 3600645b1f28d73e9cd0384b5b9664d6ceeabe7e not found' }
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
