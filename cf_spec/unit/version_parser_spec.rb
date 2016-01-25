$: << 'cf_spec'
require 'yaml'
require_relative '../../lib/version_parser'


describe VersionParser do
  let(:buildpack_dir) { File.expand_path(File.join(File.dirname(__FILE__), '..', '..')) }

  let (:manifest) { <<-MANIFEST
---
dependencies:
  - name: node
    version: 4.2.4
    uri: https://pivotal-buildpacks.s3.amazonaws.com/concourse-binaries/node/node-4.2.4-linux-x64.tgz
    md5: 081481f48b7bfabad8e2439e8aff860e
    cf_stacks:
      - cflinuxfs2
  - name: node
    version: 4.2.5
    uri: https://pivotal-buildpacks.s3.amazonaws.com/concourse-binaries/node/node-4.2.5-linux-x64.tgz
    md5: 081481f48b7bfabad8e2439e8aff860e
    cf_stacks:
      - cflinuxfs2
  - name: node
    version: 5.5.0
    uri: https://pivotal-buildpacks.s3.amazonaws.com/concourse-binaries/node/node-5.5.0-linux-x64.tgz
    md5: 45c0173cd4d92309194804766f01d945
    cf_stacks:
      - cflinuxfs2
                    MANIFEST
  }


  subject { VersionParser.new }

  describe 'with exact matching' do
    context 'on receiving an exact, supported version' do
      let(:version_string) { '4.2.5' }

      it 'returns the specified version' do
        expect(subject.match_version(version_string)).to eq '4.2.5'
      end
    end

    context 'on receiving an exact, unsupported version' do
      let(:version_string) { '4.2.3' }
      it 'returns an empty string' do
        expect(subject.match_version(version_string)).to eq ''
      end
    end
  end

  describe 'with version range matching' do
    context 'on receiving an approximate patch version' do
      let(:version_string) { '~4.2.0' }

      it 'returns the latest patched version' do
        expect(subject.match_version(version_string)).to eq '4.2.5'
      end
    end
  end
end
