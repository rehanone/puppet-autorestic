# To check the correct dependencies are set up for autorestic.

require 'spec_helper'
describe 'autorestic' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      describe 'Testing the dependencies between the classes' do
        it { is_expected.to contain_class('autorestic::account') }
        it { is_expected.to contain_class('autorestic::dependencies') }
        it { is_expected.to contain_class('autorestic::config') }
        it { is_expected.to contain_class('autorestic::install') }
        it { is_expected.to contain_class('autorestic::wrapper') }

        it { is_expected.to contain_class('autorestic::account').that_comes_before('Class[autorestic::dependencies]') }
        it { is_expected.to contain_class('autorestic::dependencies').that_comes_before('Class[autorestic::config]') }
        it { is_expected.to contain_class('autorestic::config').that_comes_before('Class[autorestic::install]') }
        it { is_expected.to contain_class('autorestic::install').that_comes_before('Class[autorestic::wrapper]') }
      end
    end
  end
end
