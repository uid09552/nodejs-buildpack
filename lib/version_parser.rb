require 'yaml'

class VersionParser
  def initialize
    manifest_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'manifest.yml'))
    @versions = YAML.load_file(manifest_file)['dependencies'].map { |dep| dep['version'] }
  end

  def match_version(target_version)
    match = ''
    match = target_version if @versions.include? target_version

    unless match || @versions.none? { |version| version =~ /^~\d+\.\d+/ }
      match = approx_match(target_version, '~').last
    end
    match
  end

  private

  def approx_match target, operator

    version_elts = target.slice[pattern.length..-1].split('.')
    version_elts.pop
    version_elts[0]
    base_ver = version_elts.join('.')

    approx_matches = @versions.select{ |ver| ver =~ base_ver }
      .sort{ |v1, v2| v1.split('.').last.to_i <=> v2.split('.').last.to_i }
  end
end
