require 'spec_helper'
require 'open3'

describe 'reditor command' do
  def capture_reditor(library_name, options = {})
    options = {editor: 'echo', on: nil, global: false}.merge(options)
    command = PROJECT_ROOT.join('bin/reditor').to_path
    project = PROJECT_ROOT.join("spec/samples/#{options[:on]}").to_path

    Bundler.with_clean_env {
      output, process = Open3.capture2e(
        {'EDITOR' => options[:editor]},
        command,
        library_name,
        "--global=#{options[:global]}",
        chdir: project
      )

      raise "Command failed: #{output}" unless process.success?

      output
    }
  end

  let(:thor_in_global_gems)     { /thor-0\.18\.*/ }
  let(:thor_in_bundler_project) { /thor-0\.14\.6/ }

  before :all do
    Bundler.with_clean_env do
      system 'bundle', chdir: PROJECT_ROOT.join('spec/samples/bundler_project').to_path
    end
  end

  describe '#open' do
    context 'Standard library in non-bundler broject (happy case)' do
      subject { capture_reditor('webrick', on: 'blank_project') }

      it { should match /webrick\.rb$/ }
    end

    context 'Incorrect name library in non-bundler broject' do
      subject { capture_reditor('cvs', on: 'blank_project') }

      it { should match /\[0\] csv/ }
    end

    context 'Rubygems library in non-bundler project' do
      subject { capture_reditor('thor', on: 'blank_project') }

      it { should match /thor-/m }

      specify 'global gem should be used' do
        subject.should_not match thor_in_bundler_project
      end
    end

    context 'Rubygems library in bundler project (installed)' do
      subject { capture_reditor('thor', on: 'bundler_project') }

      specify 'bundler gem should be used' do
        subject.should match thor_in_bundler_project
      end
    end

    context 'Rubygems library in bundler project (not yet installed)' do
      subject { capture_reditor('thor', on: 'bundler_project_without_lockfile') }

      it { should match thor_in_bundler_project }
    end

    context 'with --global option' do
      subject { capture_reditor('thor', on: 'bundler_project', global: true) }

      it { should match thor_in_global_gems }
      it { should_not match thor_in_bundler_project }
    end

    context 'with incorrect name' do
      subject { capture_reditor('rb') }

      it { should match /\[\d+\]\sirb$/ }
      it { should match /\[\d+\]\serb$/ }
      it { should match /\[\d+\]\sdrb$/ }
      it { should match /Choose number of library/ }
    end

    context 'with incorrect name and --global option' do
      subject { capture_reditor('tho', on: 'bundler_project', global: true) }

      it { should match /\[\d+\]\sthor$/ }
      it { should match /Choose number of library/ }
    end
  end
end
