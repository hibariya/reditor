require 'reditor'
require 'spec_helper'

describe Reditor::LibrarySearchQuery do
  describe '.search(query, limit)' do
    before do
      allow_any_instance_of(Reditor::LibrarySearchQuery).to receive(:candidates).and_return(
        %w(
          rails_admin
          railtie
          activemodel
          active_decorator
          action
          jquery-atwho-rails
          itwho
          csv
        )
      )
    end

    describe 'rails' do
      subject { Reditor::LibrarySearchQuery.search('rails', limit: 3) }

      it { should == %w(rails_admin jquery-atwho-rails railtie) }
    end

    describe 'rails_' do
      subject { Reditor::LibrarySearchQuery.search('rails_', limit: 2) }

      it { should == %w(rails_admin railtie) }
    end

    describe 'cvs' do
      subject { Reditor::LibrarySearchQuery.search('cvs', limit: 1) }

      it { should == %w(csv) }
    end

    describe 'atwho' do
      subject { Reditor::LibrarySearchQuery.search('atwho', limit: 2) }

      it { should == %w(jquery-atwho-rails itwho) }
    end

    describe 'active' do
      subject { Reditor::LibrarySearchQuery.search('active', limit: 3) }

      it { should == %w(activemodel active_decorator action) }
    end
  end
end
